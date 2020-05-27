class NotificationProposalCommentCreate < NotificationSender
  def perform(comment_id)
    comment = ProposalComment.find(comment_id)
    @proposal = comment.proposal
    @trackable = @proposal
    comment_user = comment.user
    nickname = ProposalNickname.find_by(user_id: comment_user.id, proposal_id: @proposal.id)
    name = nickname && @proposal.is_anonima? ? nickname.nickname : comment_user.fullname # send nickname if proposal is anonymous
    host = comment_user.locale.host
    data = { comment_id: comment.id.to_s,
             proposal_id: @proposal.id.to_s,
             to_id: "proposal_c_#{@proposal.id}",
             username: name,
             user_id: comment_user.id,
             name: name,
             title: @proposal.title,
             count: 1 }

    query = { comment_id: comment.id.to_s }
    if @proposal.private?
      group = @proposal.groups.first
      data[:group] = group.name
    end
    url = url_for_proposal

    if comment.is_contribute?
      query[:section_id] = data[:section_id] = comment.paragraph.section_id if comment.paragraph

      @proposal.users.each do |user| # send emails to editors
        next if user == comment_user

        notification_a = Notification.create!(notification_type_id: NotificationType::NEW_CONTRIBUTES_MINE, url: url + "?#{query.to_query}", data: data)
        send_notification_for_proposal(notification_a, user)
      end

      @proposal.participants.each do |user|
        next if (user == comment_user) || (@proposal.users.include? user)

        notification_b = Notification.create!(notification_type_id: NotificationType::NEW_CONTRIBUTES, url: url + "?#{query.to_query}", data: data)
        send_notification_for_proposal(notification_b, user)
      end
    else # reply

      query[:section_id] = data[:section_id] = comment.contribute.paragraph.section_id if comment.contribute.paragraph

      data[:parent_id] = comment.contribute.id

      notification_a = Notification.create(notification_type_id: NotificationType::NEW_COMMENTS,
                                           url: url + "?#{query.to_query}", data: data)

      comment.contribute.participants.each do |user|
        next if user == comment_user

        send_notification_for_proposal(notification_a, user)
      end
    end
  end
end
