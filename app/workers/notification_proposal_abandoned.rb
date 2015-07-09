class NotificationProposalAbandoned < NotificationSender

  #send alerts when a proposal is abandoned
  def perform(proposal_id, participant_ids = [])
    @proposal = Proposal.find(proposal_id)
    @trackable = @proposal
    group = @proposal.group
    data = {proposal_id: @proposal.id, title: @proposal.title, extension: 'abandoned'}

    notification_a = Notification.create(notification_type_id: NotificationType::CHANGE_STATUS_MINE,
                                         url: url_for_proposal, data: data)
    old_authors.each do |user|
      send_notification_for_proposal(notification_a, user)
    end

    notification_b = Notification.create(notification_type_id: NotificationType::CHANGE_STATUS,
                                         url: url_for_proposal, data: data)
    old_participants(participant_ids).each do |user|
      send_notification_for_proposal(notification_b, user)
    end
  end

  def old_authors
    @proposal.proposal_lives.first.users
  end

  def old_participants(participant_ids)
    User.where(id: participant_ids).where.not(id: old_authors.pluck(:id))
  end
end
