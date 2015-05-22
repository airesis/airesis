#TODO duplicated code, all that code is duplicated from notification helper. please fix it asap
class NotificationSender
  include Sidekiq::Worker, GroupsHelper, ProposalsHelper, Rails.application.routes.url_helpers

  sidekiq_options queue: :notifications, retry: 1

  def cancelled?
    Sidekiq.redis {|c| c.exists("cancelled-#{jid}") }
  end

  def self.cancel!(jid)
    Sidekiq.redis {|c| c.setex("cancelled-#{jid}", 86400, 1) }
  end

  protected



  #send notifications to the authors of a proposal
  def send_notification_to_authors(notification, proposal)
    proposal.users.each do |user|
      send_notification_for_proposal(notification, user, proposal)
    end
  end

  #invia una notifica ad un utente.
  #se l'utente ha bloccato il tipo di notifica allora non viene inviata
  #se l'utente ha abilitato anche l'invio via mail allora viene inviata via mail
  def send_notification_to_user(notification,user)
    unless user.blocked_notifications.include?notification.notification_type #se il tipo non è bloccato
      alert = Alert.new(user_id: user.id, notification_id: notification.id, checked: false)
      alert.save! #invia la notifica
      res = PrivatePub.publish_to("/notifications/#{user.id}", pull: 'hello') rescue nil  #todo send specific alert to be included
    end
    true
  end

  # invia una notifica ad un utente a meno che non abbia bloccato le notifiche per quella proposta
  # se l'utente ha bloccato il tipo di notifica allora non viene inviata
  # se l'utente ha abilitato anche l'invio via mail allora viene inviata via mail
  def send_notification_for_proposal(notification,user,proposal)
    send_notification_to_user(notification, user) unless BlockedProposalAlert.find_by(user_id: user.id, proposal_id: proposal.id)
  end


  # delete previous notifications
  # @param attribute [String] column to be checked
  # @param attr_id [String] value for the column to be checked
  # @return nil
  # @param [Integer] user_id receiver of the alert
  # @param [Integer] notification_type
  def another_delete(attribute, attr_id, user_id, notification_type)
    another = Alert.another(attribute, attr_id, user_id, notification_type)
    another.soft_delete_all
  end

  #increase previous notification
  def another_increase_or_do(attribute, attr_id, user_id, notification_type, &block)
    another = Alert.another_unread(attribute, attr_id, user_id, notification_type).first
    if another
      another.increase_count!
      PrivatePub.publish_to("/notifications/#{user_id}", pull: 'hello') rescue nil #todo send specific alert to be included
    else
      block.call
    end
  end


  def url_for_proposal(proposal,group=nil)
    group ? group_proposal_url(group, proposal) : proposal_url(proposal)
  end
end
