class NotificationProposalVoteClosed < NotificationSender

  def perform(proposal_id)
    proposal = Proposal.find(proposal_id)
    group = proposal.group
    group_area = proposal.group_area
    data = {proposal_id: proposal.id.to_s, :title => proposal.title}
    data[:extension] = proposal.accepted? ? 'voted' : 'rejected'
    if group
      data[:group] = group.name
      data[:subdomain] = group.subdomain if group.certified?
    end
    notification_a = Notification.create(notification_type_id: NotificationType::CHANGE_STATUS_MINE, url: url_for_proposal(proposal, group), data: data)
    send_notification_to_authors(notification_a, proposal)
    notification_b = Notification.create(notification_type_id: NotificationType::CHANGE_STATUS, url: url_for_proposal(proposal, group), data: data)
    if proposal.accepted?
      send_notification_to_voters(notification_b, proposal)
    else #rejected
      send_notification_to_participants(notification_b, proposal)
    end
  end

  protected

  def send_notification_no_authors(users, notification, proposal)
    users.each do |user|
      unless proposal.users.include? user
        another_delete('proposal_id', proposal.id, user.id, NotificationType::PHASE_ENDING)
        send_notification_for_proposal(notification, user, proposal)
      end
    end
  end

  #all with the right to vote (no authors)
  def send_notification_to_voters(notification, proposal)
    send_notification_no_authors(voters(proposal), notification, proposal)
  end

  #participants (no authors)
  def send_notification_to_participants(notification, proposal)
    send_notification_no_authors(proposal.participants, notification, proposal)
  end

  #people with the right to vote for the proposal
  def voters(proposal)
    return proposal.group_area.scoped_participants(GroupAction::PROPOSAL_VOTE) if proposal.group_area
    return proposal.group.scoped_participants(GroupAction::PROPOSAL_VOTE) if proposal.group
    proposal.participants
  end
end
