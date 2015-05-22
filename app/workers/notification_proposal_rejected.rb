class NotificationProposalRejected < NotificationSender

  def perform(proposal_id)
    @proposal = Proposal.find(proposal_id)
    @trackable = @proposal
    group = @proposal.group
    group_area = @proposal.group_area

    data = {proposal_id: @proposal.id, title: @proposal.title, extension: 'rejected'}
    if group
      data['group'] = group.name
      data['subdomain'] = group.subdomain if group.certified?
    end
    notification_a = Notification.create(notification_type_id: NotificationType::CHANGE_STATUS_MINE,
                                         url: url_for_proposal, data: data)
    send_notification_to_authors(notification_a)

    notification_b = Notification.create(notification_type_id: NotificationType::CHANGE_STATUS,
                                         url: group ? group_proposal_url(group, @proposal) : proposal_url(@proposal), data: data)
    @proposal.participants.each do |user|
      unless @proposal.users.include? user
        another_delete('proposal_id', @proposal.id, user.id, NotificationType::PHASE_ENDING)
        send_notification_for_proposal(notification_b, user)
      end
    end
  end
end
