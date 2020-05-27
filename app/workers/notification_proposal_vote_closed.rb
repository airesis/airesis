class NotificationProposalVoteClosed < NotificationSender
  def perform(proposal_id)
    @proposal = Proposal.find(proposal_id)
    @trackable = @proposal
    group = @proposal.group
    group_area = @proposal.group_area
    data = { proposal_id: @proposal.id, title: @proposal.title }
    data[:extension] = @proposal.accepted? ? 'voted' : 'rejected'
    data[:group] = group.name if group
    notification_a = Notification.create(notification_type_id: NotificationType::CHANGE_STATUS_MINE,
                                         url: url_for_proposal, data: data)
    send_notification_to_authors(notification_a)
    notification_b = Notification.create(notification_type_id: NotificationType::CHANGE_STATUS,
                                         url: url_for_proposal, data: data)
    if @proposal.accepted?
      send_notification_to_voters(notification_b)
    else # rejected
      send_notification_to_participants(notification_b)
    end
  end

  protected

  def send_notification_no_authors(users, notification)
    users.each do |user|
      send_notification_for_proposal(notification, user) unless @proposal.users.include? user
    end
  end

  # all with the right to vote (no authors)
  def send_notification_to_voters(notification)
    send_notification_no_authors(voters, notification)
  end

  # participants (no authors)
  def send_notification_to_participants(notification)
    send_notification_no_authors(@proposal.participants, notification)
  end

  # people with the right to vote for the proposal
  def voters
    return @proposal.group_area.scoped_participants(:vote_proposals) if @proposal.group_area
    return @proposal.group.scoped_participants(:vote_proposals) if @proposal.group

    @proposal.participants
  end
end
