class NotificationProposalCreate < NotificationSender

  def perform(proposal_id)
    @proposal = Proposal.find(proposal_id)
    @trackable = @proposal
    current_user = @proposal.users.first
    group = @proposal.group
    group_area = @proposal.group_area
    data = {proposal_id: @proposal.id, proposal: @proposal.title}
    host = current_user.locale.host #TODO not correct. l'host dovrebbe essere quello di chi riceve la mail ma allora dobbiamo spostare l'url nell'alert. da fare nella 5.0
    if group #if it's a group proposal
      data[:group_id] = group.id.to_s
      data[:group] = group.name
      data[:subdomain] = group.subdomain if group.certified?

      if group_area
        data[:group_area_id] = group_area.id.to_s
        data[:group_area] = group_area.name
        receivers = group_area.scoped_participants(GroupAction::PROPOSAL_VIEW)
      else
        receivers = group.scoped_participants(GroupAction::PROPOSAL_VIEW)
      end
      notification_a = Notification.create(notification_type_id: NotificationType::NEW_PROPOSALS, url: group_proposal_url(group, @proposal, host: host), data: data)
      receivers.each do |user|
        next if user == current_user
        send_notification_to_user(notification_a, user)
      end
    else
      #if it'a a public proposal
      notification_a = Notification.create(notification_type_id: NotificationType::NEW_PUBLIC_PROPOSALS, url: proposal_url(@proposal, {subdomain: false, host: host}), data: data)
      User.non_blocking_notification(NotificationType::NEW_PUBLIC_PROPOSALS).find_each do |user|
        next if user == current_user
        send_notification_to_user(notification_a, user)
      end
    end
  end
end
