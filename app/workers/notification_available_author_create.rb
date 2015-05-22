class NotificationAvailableAuthorCreate < NotificationSender
  def perform(available_author_id)
    set_instance_variables(available_author_id)

    notification_a = build_notification
    proposal.users.each do |user|
      send_notification_for_proposal(notification_a, user)
    end
  end

  def build_notification
    data = {'proposal_id' => @proposal.id.to_s, 'user' => @user.fullname, 'user_id' => @user.id, 'title' => @proposal.title}
    Notification.create(notification_type_id: @notification_type_id, url: url_for_proposal, data: data)
  end

  def set_instance_variables(available_author_id)
    @available_author = AvailableAuthor.find(available_author_id)
    @proposal = available_author.proposal
    @trackable = @proposal
    @user = available_author.user
    @notification_type_id = NotificationType::AVAILABLE_AUTHOR
  end
end
