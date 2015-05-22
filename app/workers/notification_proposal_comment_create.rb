class NotificationProposalCommentCreate < NotificationSender

  def perform(comment_id)
    comment = ProposalComment.find(comment_id)
    @proposal = comment.proposal
    @trackable = @proposal
    comment_user = comment.user
    nickname = ProposalNickname.find_by(user_id: comment_user.id, proposal_id: @proposal.id)
    name = (nickname && @proposal.is_anonima?) ? nickname.nickname : comment_user.fullname # send nickname if proposal is anonymous
    host = comment_user.locale.host
    data = {comment_id: comment.id.to_s,
            proposal_id: @proposal.id.to_s,
            to_id: "proposal_c_#{@proposal.id}",
            username: name,
            name: name,
            title: @proposal.title,
            count: 1}

    query = {comment_id: comment.id.to_s}
    if @proposal.private?
      group = @proposal.groups.first
      data[:group] = group.name
      data[:subdomain] = group.subdomain if group.certified?
    else
    end
    url = url_for_proposal

    if comment.is_contribute?
      if comment.paragraph
        query[:section_id] = data[:section_id] = comment.paragraph.section_id
      end

      @proposal.users.each do |user| #send emails to editors
        if user != comment_user
          #check if there is another alert to this user about new contributes that he has not read yet
          another_increase_or_do('proposal_id', @proposal.id, user.id, NotificationType::NEW_CONTRIBUTES_MINE) do
            #for contributes we create a notification for each user and aggregate them if needed
            notification_a = Notification.create!(notification_type_id: NotificationType::NEW_CONTRIBUTES_MINE, url: url + "?#{query.to_query}", data: data)
            send_notification_for_proposal(notification_a, user)
          end
        end
      end

      @proposal.participants.each do |user|
        if (user != comment_user) && (!@proposal.users.include? user)
          another_increase_or_do('proposal_id', @proposal.id, user.id, NotificationType::NEW_CONTRIBUTES) do
            notification_b = Notification.create!(notification_type_id: NotificationType::NEW_CONTRIBUTES, url: url +"?#{query.to_query}", data: data)
            #for contributes we create a notification for each user and aggregate them if needed
            send_notification_for_proposal(notification_b, user)
          end
        end
      end
    else #reply

      if comment.contribute.paragraph
        query[:section_id] = data[:section_id] = comment.contribute.paragraph.section_id
      end

      data[:parent_id] = comment.contribute.id

      notification_a = Notification.create(notification_type_id: NotificationType::NEW_COMMENTS,
                                           url: url +"?#{query.to_query}", data: data)

      comment.contribute.participants.each do |user|
        unless user == comment_user
          another_increase_or_do('parent_id', comment.contribute.id, user.id, NotificationType::NEW_COMMENTS) do
            send_notification_for_proposal(notification_a, user)
          end
        end
      end
    end
  end
end
