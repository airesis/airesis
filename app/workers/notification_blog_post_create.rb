class NotificationBlogPostCreate < NotificationSender
  include GroupsHelper, Rails.application.routes.url_helpers

  @queue = :notifications

  def self.perform(blog_post_id)
    NotificationBlogPostCreate.new.elaborate(blog_post_id)
  end

  #invia le notifiche quando un utente inserisce un post sul proprio blog
  #le notifiche vengono inviate agli utenti che seguono il blog dell'autore,
  #agli utenti che seguono o partecipano ai gruppi in cui il post è stato inserito
  def elaborate(blog_post_id)
    blog_post = BlogPost.find(blog_post_id)
    post_user = blog_post.user
    user_followers = post_user.followers #utenti che seguono il blog
    sent_users = []
    data = {'blog_post_id' => blog_post.id.to_s}
    notification_a = Notification.new(:notification_type_id => 15, :url => blog_blog_post_url(blog_post.blog, blog_post), data: data)
    notification_a.save
    #TODO followers are not yet supported
    user_followers.each do |user|
      if (user != post_user) && (!sent_users.include? user)
        if send_notification_to_user(notification_a, user)
          sent_users << user
        end
      end
    end

    blog_post.groups.each do |group|
      data = {'blog_post_id' => blog_post.id.to_s, 'group_id' => group.id, 'user' => current_user.fullname, 'group' => group.name, 'i18n' => 't'}
      data['subdomain'] = group.subdomain if group.certified?

      #notifica a chi partecipa al gruppo
      notification_b = Notification.create(:notification_type_id => NotificationType::NEW_POST_GROUP, :url => group_blog_post_url(group, blog_post), data: data)
      group.partecipants.each do |user|
        if (user != post_user) && (!sent_users.include? user)
          if send_notification_to_user(notification_b, user)
            sent_users << user
          end
        end
      end
    end
  end
end