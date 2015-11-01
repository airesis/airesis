class NotificationProposalVoteStarts < NotificationSender
  def perform(proposal_id, group_id = nil, group_area_id = nil)
    @proposal = Proposal.find(proposal_id)
    @trackable = @proposal
    group = Group.find(group_id) if group_id
    group_area = GroupArea.find(group_area_id) if group_area_id

    data = { proposal_id: @proposal.id, title: @proposal.title, extension: 'in_vote' }
    notification_a = Notification.create(notification_type_id: NotificationType::CHANGE_STATUS_MINE,
                                         url: url_for_proposal, data: data)

    send_notification_to_authors(notification_a)

    notification_b = Notification.create(notification_type_id: NotificationType::CHANGE_STATUS,
                                         url: url_for_proposal, data: data)

    users = group ?
      group_area ?
        group_area.scoped_participants(GroupAction::PROPOSAL_VOTE) :
        group.scoped_participants(GroupAction::PROPOSAL_VOTE) :
      @proposal.participants

    users.each do |user|
      unless @proposal.users.include? user
        send_notification_for_proposal(notification_b, user)
      end
    end
  end
end
