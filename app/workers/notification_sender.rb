#TODO duplicated code, all that code is duplicated from notification helper. please fix it asap
class NotificationSender
  include Sidekiq::Worker, GroupsHelper, ProposalsHelper, Rails.application.routes.url_helpers

  sidekiq_options queue: :notifications, retry: 1

  protected

  #send notifications to the authors of a proposal
  def send_notification_to_authors(notification)
    proposal.users.each do |user|
      send_notification_for_proposal(notification, user)
    end
  end

  ###

  # check if the user blocked alerts from the proposal and then send the alert
  def send_notification_for_proposal(notification, user)
    return if BlockedProposalAlert.find_by(user: user, proposal: @proposal)
    send_notification_to_user(notification, user)
  end

  # TODO: implement
  def check_destroyable(notification, user)
    destroyable = notification.notification_type.destroyable #list of destroyable notification types
    destroyable.each do |notification_type|
      alert_jobs = search_alert_jobs(notification_type, user)
      alert_jobs.each do |alert_job|
        if alert_job.completed?
          alert_job.alert.soft_delete
          email_job = alert_job.alert.email_job
          email_job.canceled! unless email_job.completed?
        else
          alert_job.canceled!
        end
      end
    end
  end

  def build_alert(notification, user)
    AlertJob.factory(notification, user, @trackable)
  end

  # send an alert to the user
  # if the user blocked the notificaiton type, then the alert is not sent
  def send_notification_to_user(notification, user)
    return if user.blocked_notifications.include? notification.notification_type #se il tipo non è bloccato
    check_destroyable(notification, user)
    if notification.notification_type.cumulable?
      send_cumulable_alert_to_user(notification, user)
    else # this notification type is not cumulable. just send it
      build_alert(notification, user)
    end
  end

  def send_cumulable_alert_to_user(notification, user)
    alert_job = search_for_cumulable(notification.notification_type, user)
    if alert_job.present? # an alert is already in queue
      alert_job.accumulate(1) #accumulate one notification on the previous one
    else # no alerts in queue
      alert = search_for_unread_alert(user, notification.notification_type)
      if alert # we have an unread alert, already sent
        alert.accumulate(1)
      else # last alert has been already checked. no email will be sent then (or has already been sent)...create a new alert
        build_alert(notification, user)
      end
    end
  end

  def search_for_unread_alert(user, notification_type)
    Alert.joins(:notification).
      find_by(checked: false, user: user, trackable: @trackable, notifications: {notification_type_id: notification_type.id})
  end

  def search_for_cumulable(notification_type, user)
    search_alert_jobs(notification_type, user).where(status: 0).first
  end

  def search_alert_jobs(notification_type, user)
    AlertJob.where(notification_type: notification_type, user: user, trackable: @trackable)
  end

  ###

  # delete previous notifications
  # @param attribute [String] column to be checked
  # @param attr_id [String] value for the column to be checked
  # @return nil
  # @param [Integer] user_id receiver of the alert
  # @param [Integer] notification_type
  # @deprecated
  def another_delete(attribute, attr_id, user_id, notification_type)
    another = Alert.another(attribute, attr_id, user_id, notification_type)
    another.soft_delete_all
  end

  #increase previous notification
  ## @deprecated
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
