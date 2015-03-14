class NotificationBlogCommentCreate < NotificationSender

  #notify blog owner of new comments
  def perform(comment_id)
    blog_comment = BlogComment.find(comment_id)
    blog_post = blog_comment.blog_post
    post_user = blog_post.user
    comment_user = blog_comment.user
    return if comment_user == post_user #don't send a notification to myself
    another = Alert.another('blog_post_id', blog_post.id, post_user.id, NotificationType::NEW_BLOG_COMMENT).first
    if another
      another.increase_count!
      PrivatePub.publish_to("/notifications/#{post_user.id}", pull: 'hello') rescue nil #todo send specific alert to be included
    else
      data = {blog_post_id: blog_post.id.to_s, blog_comment_id: blog_comment.id.to_s, user: comment_user.fullname, user_id: comment_user.id, title: blog_post.title, count: 1}
      notification_a = Notification.create!(notification_type_id: NotificationType::NEW_BLOG_COMMENT, url: blog_blog_post_url(blog_post.blog, blog_post), data: data)
      send_notification_to_user(notification_a, post_user)
    end
  end
end
