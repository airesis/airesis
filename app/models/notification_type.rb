class NotificationType < ActiveRecord::Base
  belongs_to :notification_category, :class_name => 'NotificationCategory', :foreign_key => :notification_category_id
  has_many :blocked_alerts, :class_name => 'BlockedAlert'
  has_many :notifications, :class_name => 'Notification'
  has_many :blockers, :through => :blocked_alerts, :class_name => 'User', :source => :user

end
