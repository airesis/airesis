class NotificationForForumTopics < ActiveRecord::Migration
  def up
    NotificationType.create!(name: NotificationType::NEW_FORUM_TOPIC, notification_category: NotificationCategory.find_by(short: 'GROUPS'), email_delay: 2, alert_delay: 1, cumulable: false)
  end

  def down
    NotificationType.find_by(name: NotificationType::NEW_FORUM_TOPIC).destroy
  end
end
