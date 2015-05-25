class NotificationProposalCommentUnintegrate < NotificationSender
  def perform(proposal_comment_id)
    proposal_comment = ProposalComment.find(proposal_comment_id)
    @proposal = proposal_comment.proposal
    @trackable = @proposal
    group = @proposal.groups.first if @proposal.in_group?
    comment_user = proposal_comment.user
    nickname = ProposalNickname.find_by(user_id: comment_user.id, proposal_id: @proposal.id)
    name = @proposal.is_anonima? ? nickname.nickname : comment_user.fullname #send nickname if proposal is anonymous

    data = {proposal_id: @proposal.id, comment_id: proposal_comment.id, username: name, proposal: @proposal.title}

    if group
      data[:group] = group.name
      data[:subdomain] = group.subdomain if group.certified?
    end

    notification_a = Notification.new(notification_type_id: NotificationType::UNINTEGRATED_CONTRIBUTE,
                                      url: url_for_proposal,
                                      data: data)
    notification_a.save
    @proposal.users.each do |user|
      send_notification_for_proposal(notification_a, user) unless user == comment_user
    end
  end
end
