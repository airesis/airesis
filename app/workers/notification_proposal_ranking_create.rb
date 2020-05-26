class NotificationProposalRankingCreate < NotificationSender
  # send alerts when there is a new evaluatation for the proposal #todo test
  def perform(proposal_ranking_id)
    proposal_ranking = ProposalRanking.find(proposal_ranking_id)
    @proposal = proposal_ranking.proposal
    @trackable = @proposal
    group = @proposal.groups.first if @proposal.in_group?

    data = { proposal_id: @proposal.id, title: @proposal.title }
    notification_a = Notification.create(notification_type_id: NotificationType::NEW_VALUTATION_MINE,
                                         url: url_for_proposal, data: data)
    @proposal.users.each do |author|
      send_notification_for_proposal(notification_a, author) if author != proposal_ranking.user
    end
    notification_b = Notification.create(notification_type_id: NotificationType::NEW_VALUTATION,
                                         url: url_for_proposal, data: data)
    @proposal.participants.each do |participant|
      send_notification_for_proposal(notification_b, participant) if (participant != proposal_ranking.user) && @proposal.users.exclude?(participant)
    end
  end
end
