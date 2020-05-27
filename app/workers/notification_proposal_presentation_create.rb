class NotificationProposalPresentationCreate < NotificationSender
  def perform(proposal_presentation_id)
    elaborate(proposal_presentation_id)
  end

  def elaborate(proposal_presentation_id)
    proposal_presentation = ProposalPresentation.find(proposal_presentation_id)
    @proposal = proposal_presentation.proposal
    @trackable = @proposal
    user = proposal_presentation.user
    acceptor = proposal_presentation.acceptor
    data = { proposal_id: @proposal.id, user_id: user.id, title: @proposal.title }
    notification_a = Notification.create(notification_type_id: NotificationType::AUTHOR_ACCEPTED,
                                         url: url_for_proposal, data: data)
    send_notification_for_proposal(notification_a, user)

    nickname = ProposalNickname.find_by(user_id: user.id, proposal_id: @proposal.id)
    name = nickname && @proposal.is_anonima? ? nickname.nickname : user.fullname # send nickname if proposal is anonymous
    data = { proposal_id: @proposal.id, user_id: user.id.to_s, user: name, title: @proposal.title }
    notification_b = Notification.create(notification_type_id: NotificationType::NEW_AUTHORS,
                                         url: url_for_proposal, data: data)
    @proposal.participants.each do |participant|
      send_notification_for_proposal(notification_b, participant) unless [user, acceptor].include? participant
    end
  end
end
