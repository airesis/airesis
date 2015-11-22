class NotificationForumTopicCreate < NotificationSender

  # new forum topic created
  # we send alerts to the group members
  def perform(frm_topic_id)
    frm_topic = Frm::Topic.find(frm_topic_id)
    forum = frm_topic.forum
    post_user = frm_topic.user
    group = forum.group
    notification_type = NotificationType.find_by(name: NotificationType::NEW_FORUM_TOPIC)
    @trackable = frm_topic

    data = { topic_subject: frm_topic.subject, group_name: group.name }
    notification = Notification.create(notification_type: notification_type, url: group_forum_topic_url(forum.group, forum, frm_topic), data: data)
    data[:subdomain] = group.subdomain if group.certified?

    group.participants.each do |user|
      next if (user == post_user)
      send_notification_to_user(notification, user)
    end
  end
end
