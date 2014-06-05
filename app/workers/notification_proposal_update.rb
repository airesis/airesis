class NotificationProposalUpdate < NotificationSender
  include Sidekiq::Worker, GroupsHelper, Rails.application.routes.url_helpers

  def perform(current_user_id,proposal_id,group_id = nil)
    elaborate(current_user_id,proposal_id,group_id)
  end

  #invia le notifiche quando un una proposta viene creata
  def elaborate(current_user_id,proposal_id,group_id = nil)
    proposal = Proposal.find(proposal_id)
    current_user = User.find(current_user_id)
    group = Group.find(group_id) if group_id
    host = current_user.locale.host
    data = {'proposal_id' => proposal.id.to_s, 'revision_id' => (proposal.last_revision.try(:id)), 'title' => proposal.title, 'i18n' => 't'}
    if group
      data['group'] = group.name
      data['subdomain'] = group.subdomain if group.certified?
    end
    notification_a = Notification.new(notification_type_id: NotificationType::TEXT_UPDATE, url: group ? group_proposal_url(group, proposal,{host: host}) : proposal_url(proposal,{host: host}), data: data)
    notification_a.save
    proposal.participants.each do |user|
      if user != current_user
        #non inviare la notifica se l'utente ne ha già una uguale sulla stessa proposta che ancora non ha letto
        another = Notification.first(joins: [:notification_data, alerts: [:user]], conditions: ['notification_data.name = ? and notification_data.value = ? and notifications.notification_type_id = ? and users.id = ? and alerts.checked = false', 'proposal_id', proposal.id.to_s, 2, user.id.to_s])
        send_notification_to_user(notification_a, user) unless (another || BlockedProposalAlert.find_by_user_id_and_proposal_id(user.id, proposal.id))
      end
    end
  end
end