class CommentUpdateNotification < ActiveRecord::Migration
  def up
    NotificationType.create( notification_category_id: NotificationCategory.find_by_short('PROP').id, name: 'contribute_update' ){ |c| c.id = 29 }.save

  end

  def down
    NotificationType.find_by_name('contribute_update').destroy
  end
end
