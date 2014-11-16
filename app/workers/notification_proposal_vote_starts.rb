class NotificationProposalVoteStarts < NotificationSender

  def perform(proposal_id, group_id=nil, group_area_id = nil)
    elaborate(proposal_id, group_id, group_area_id)
  end

  #invia le notifiche quando un una proposta viene creata
  def elaborate(proposal_id, group_id=nil, group_area_id = nil)
    proposal = Proposal.find(proposal_id)
    group = Group.find(group_id) if group_id
    group_area = GroupArea.find(group_area_id) if group_area_id

    data = {'proposal_id' => proposal.id.to_s, 'title' => proposal.title, 'i18n' => 't', 'extension' => 'in_vote'}
    notification_a = Notification.new(notification_type_id: NotificationType::CHANGE_STATUS_MINE, url: url_for_proposal(proposal, group), data: data)
    notification_a.save

    proposal.users.each do |user|
      send_notification_for_proposal(notification_a, user, proposal)
    end

    notification_b = Notification.new(notification_type_id: NotificationType::CHANGE_STATUS, url: url_for_proposal(proposal, group), data: data)
    notification_b.save

    users = group ?
        group_area ?
            group_area.scoped_participants(GroupAction::PROPOSAL_VOTE) :
            group.scoped_participants(GroupAction::PROPOSAL_VOTE) :
        proposal.participants

    users.each do |user|
      unless proposal.users.include? user
        another_delete('proposal_id', proposal.id, user.id, [NotificationType::NEW_PROPOSALS, NotificationType::NEW_PUBLIC_PROPOSALS, NotificationType::PHASE_ENDING])
        send_notification_for_proposal(notification_b, user, proposal)
      end
    end
  end
end
