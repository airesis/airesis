class NotificationProposalVoteClosed < NotificationSender

  def perform(proposal_id)
    elaborate(proposal_id)
  end

  def elaborate(proposal_id)
    proposal = Proposal.find(proposal_id)
    group = proposal.group
    group_area = proposal.group_area
    if proposal.accepted?
      data = {'proposal_id' => proposal.id.to_s, 'title' => proposal.title, 'extension' => 'voted'}

      notification_a = Notification.new(notification_type_id: NotificationType::CHANGE_STATUS_MINE, url: url_for_proposal(proposal, group), data: data)
      notification_a.save
      send_notification_to_authors(notification_a, proposal)

      notification_b = Notification.new(notification_type_id: NotificationType::CHANGE_STATUS, url: url_for_proposal(proposal, group), data: data)
      notification_b.save
      send_notification_to_voters(notification_b, proposal)
    else #rejected
      data = {'proposal_id' => proposal.id.to_s, 'title' => proposal.title, 'extension' => 'rejected'}
      if group
        data['group'] = group.name
        data['subdomain'] = group.subdomain if group.certified?
      end
      notification_a = Notification.new(notification_type_id: NotificationType::CHANGE_STATUS_MINE, url: url_for_proposal(proposal, group), data: data)
      notification_a.save
      send_notification_to_authors(notification_a, proposal)

      notification_b = Notification.create(notification_type_id: NotificationType::CHANGE_STATUS, url: url_for_proposal(proposal, group), data: data)
      send_notification_to_participants(notification_b, proposal)
    end
  end


  #all with the right to vote (no authors)
  def send_notification_to_voters(notification, proposal)
    voters(proposal).each do |user|
      unless proposal.users.include? user
        another_delete('proposal_id', proposal.id, user.id, NotificationType::PHASE_ENDING)
        send_notification_for_proposal(notification, user, proposal)
      end
    end
  end

  #participants (no authors)
  def send_notification_to_participants(notification, proposal)
    proposal.participants.each do |user|
      unless proposal.users.include? user
        another_delete('proposal_id', proposal.id, user.id, NotificationType::PHASE_ENDING)
        send_notification_for_proposal(notification, user, proposal)
      end
    end
  end

  #people with the right to vote for the proposal
  def voters(proposal)
    return proposal.group_area.scoped_participants(GroupAction::PROPOSAL_VOTE) if proposal.group_area
    return proposal.group.scoped_participants(GroupAction::PROPOSAL_VOTE) if proposal.group
    proposal.participants
  end
end
