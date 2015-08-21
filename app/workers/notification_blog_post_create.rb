class NotificationBlogPostCreate < NotificationSender
  # new blog post inserted
  # we send alerts to the blog followers (TODO)
  # we send alerts to the participants in the group in which is published
  def perform(blog_post_id)
    blog_post = BlogPost.find(blog_post_id)
    post_user = blog_post.user
    user_followers = post_user.followers
    sent_users = []
    @trackable = blog_post

    data = {blog_post_id: blog_post.id, user_id: post_user.id}
    notification_a = Notification.create(notification_type_id: 15, url: blog_blog_post_url(blog_post.blog, blog_post), data: data)
    # TODO: followers are not yet supported
    user_followers.each do |user|
      next if (user == post_user) || (sent_users.include? user)
      sent_users << user if send_notification_to_user(notification_a, user)
    end

    blog_post.groups.each do |group|
      data = {blog_post_id: blog_post.id, group_id: group.id, user: post_user.fullname, user_id: post_user.id, group: group.name}
      data[:subdomain] = group.subdomain if group.certified?

      # notify group participants, if they are also blog followers, do not notify them twice
      notification_b = Notification.create(notification_type_id: NotificationType::NEW_POST_GROUP,
                                           url: group_blog_post_url(group, blog_post), data: data)
      group.participants.each do |user|
        next if (user == post_user) || (sent_users.include? user)
        sent_users << user if send_notification_to_user(notification_b, user)
      end
    end
  end
end
