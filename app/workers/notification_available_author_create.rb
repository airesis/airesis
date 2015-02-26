class NotificationAvailableAuthorCreate < NotificationSender
  def perform(available_author_id)
    available_author = AvailableAuthor.find(available_author_id)
    proposal = available_author.proposal
    user = available_author.user
    data = {'proposal_id' => proposal.id.to_s, 'user' => user.fullname, 'user_id' => user.id, 'title' => proposal.title}
    notification_a = Notification.create(notification_type_id: NotificationType::AVAILABLE_AUTHOR, url: url_for_proposal(proposal, proposal.group), data: data)
    proposal.users.each do |user|
      send_notification_for_proposal(notification_a, user, proposal)
    end
  end
end
