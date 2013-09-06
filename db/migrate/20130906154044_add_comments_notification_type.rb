class AddCommentsNotificationType < ActiveRecord::Migration
  def up
    NotificationType.create(notification_category_id: 6, name: 'new_comments_mine'  ){ |c| c.id = 27 }.save
    NotificationType.create(notification_category_id: 7, name: 'new_comments'  ){ |c| c.id = 28 }.save
  end

  def down
    NotificationType.find(27).destroy
    NotificationType.find(28).destroy
  end
end
