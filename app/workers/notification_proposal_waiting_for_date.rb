class NotificationProposalWaitingForDate < NotificationSender

  def perform(proposal_id, user_id)
    @proposal = Proposal.find(proposal_id)
    @trackable = @proposal
    group = @proposal.group
    current_user = User.find(user_id)
    nickname = ProposalNickname.find_by(user_id: current_user.id, proposal_id: @proposal.id)
    name = (@proposal.is_anonima? && nickname) ? nickname.nickname : current_user.fullname
    data = {proposal_id: @proposal.id, name: name, title: @proposal.title, extension: 'waiting_date'}
    if group
      data['group'] = group.name
      data['subdomain'] = group.subdomain if group.certified?
    end
    notification_a = Notification.create(notification_type_id: NotificationType::CHANGE_STATUS,
                                         url: url_for_proposal, data: data)
    @proposal.participants.each do |user|
      if user != current_user
        send_notification_for_proposal(notification_a, user)
      end
    end
  end
end
