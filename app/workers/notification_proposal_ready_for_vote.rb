class NotificationProposalReadyForVote < NotificationSender
  # send alerts when the debate is closed and the authors must choose a date for the votation
  def perform(proposal_id)
    @proposal = Proposal.find(proposal_id)
    @trackable = @proposal
    group = @proposal.group
    data = { proposal_id: @proposal.id, title: @proposal.title, extension: 'wait' }
    data['group'] = group.name if @proposal.in_group?
    notification_a = Notification.create(notification_type_id: NotificationType::CHANGE_STATUS_MINE,
                                         url: url_for_proposal, data: data)
    send_notification_to_authors(notification_a)
  end
end
