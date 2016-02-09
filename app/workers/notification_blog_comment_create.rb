class NotificationBlogCommentCreate < NotificationSender
  # notify blog owner of new comments
  def perform(comment_id)
    blog_comment = BlogComment.find(comment_id)
    blog_post = blog_comment.blog_post
    @trackable = blog_post
    post_user = blog_post.user
    comment_user = blog_comment.user
    return if comment_user == post_user # don't send a notification to myself
    data = { blog_post_id: blog_post.id,
             blog_comment_id: blog_comment.id,
             user: comment_user.fullname,
             user_id: comment_user.id,
             title: blog_post.title, count: 1 }
    notification_a = Notification.create!(notification_type_id: NotificationType::NEW_BLOG_COMMENT,
                                          url: blog_blog_post_url(blog_post.blog, blog_post), data: data)
    send_notification_to_user(notification_a, post_user)
  end
end
