class NotificationProposalReadyForVote < NotificationSender

  #send alerts when the debate is closed and the authors must choose a date for the votation
  def perform(proposal_id)
    proposal = Proposal.find(proposal_id)
    group = proposal.group
    data = {proposal_id: proposal.id.to_s, title: proposal.title, extension: 'wait'}
    if proposal.in_group?
      data['group'] = group.name
      data['subdomain'] = group.subdomain if group.certified?
    end
    notification_a = Notification.create(notification_type_id: NotificationType::CHANGE_STATUS_MINE, url: url_for_proposal(proposal, group), data: data)
    send_notification_to_authors(notification_a, proposal)
  end
end
