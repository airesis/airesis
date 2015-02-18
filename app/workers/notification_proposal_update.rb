class NotificationProposalUpdate < NotificationSender

  def perform(current_user_id, proposal_id, group_id = nil)
    proposal = Proposal.find(proposal_id)
    current_user = User.find(current_user_id) if current_user_id
    group = Group.find(group_id) if group_id
    host = current_user.locale.host
    data = {'proposal_id' => proposal.id.to_s, 'revision_id' => (proposal.last_revision.try(:id)), 'title' => proposal.title}
    if group
      data['group'] = group.name
      data['subdomain'] = group.subdomain if group.certified?
    end
    notification_a = Notification.new(notification_type_id: NotificationType::TEXT_UPDATE, url: url_for_proposal(proposal, group), data: data)
    notification_a.save
    proposal.participants.each do |user|
      if user != current_user
        #non inviare la notifica se l'utente ne ha già una uguale sulla stessa proposta che ancora non ha letto
        another = Notification.
            joins(:notification_data, alerts: :user).
            where(notification_data: {name: 'proposal_id', value: proposal.id.to_s},
                  notifications: {notification_type_id: NotificationType::TEXT_UPDATE},
                  users: {id: user.id}, alerts: {checked: false}).first
        send_notification_for_proposal(notification_a, user, proposal) unless another
      end
    end
  end
end
