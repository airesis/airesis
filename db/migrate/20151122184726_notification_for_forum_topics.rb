class NotificationForForumTopics < ActiveRecord::Migration
  def up
    notification_type = NotificationType.create!(name: NotificationType::NEW_FORUM_TOPIC, notification_category: NotificationCategory.find_by(short: 'GROUPS'), email_delay: 2, alert_delay: 1, cumulable: false)
    User.all.each do |user|
      user.blocked_alerts.create(notification_type: notification_type)
    end
  end

  def down
    NotificationType.find_by(name: NotificationType::NEW_FORUM_TOPIC).destroy
  end
end
