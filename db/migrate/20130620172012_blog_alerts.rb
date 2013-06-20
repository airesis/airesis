class BlogAlerts < ActiveRecord::Migration
  def up
    I18n.locale = :it

    NotificationType.create(description: 'Nuovo commento nel mio blog', notification_category_id: NotificationCategory.find_by_short('GROUPS').id, email_subject: "E' stato inserito un nuovo commento nel tuo blog" ){ |c| c.id = 26}.save

    I18n.locale = :eu
    NotificationType.find_by_id(26).update_attributes({description: "New comment in my blog",email_subject: "There's a new comment in your blog"})
    I18n.locale = :en
    NotificationType.find_by_id(26).update_attributes({description: "New comment in my blog",email_subject: "There's a new comment in your blog"})
    I18n.locale = :us
    NotificationType.find_by_id(26).update_attributes({description: "New comment in my blog",email_subject: "There's a new comment in your blog"})


  end

  def down
    NotificationType.find(26).destroy
  end
end
