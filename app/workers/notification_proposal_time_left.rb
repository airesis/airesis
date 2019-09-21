class NotificationProposalTimeLeft < NotificationSender
  def perform(proposal_id, type)
    @proposal = Proposal.find(proposal_id)
    @trackable = @proposal
    data = { proposal_id: @proposal.id, title: @proposal.title, extension: type }
    group = @proposal.group
    data['group'] = group.name if group
    notification_a = Notification.create(notification_type_id: NotificationType::PHASE_ENDING,
                                         url: url_for_proposal, data: data)
    receivers.each do |user|
      send_notification_for_proposal(notification_a, user)
    end
  end

  def receivers
    @proposal.notification_receivers
  end
end
