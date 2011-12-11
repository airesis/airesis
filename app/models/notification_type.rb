class NotificationType < ActiveRecord::Base
  belongs_to :notification_category, :class_name => 'NotificationCategory', :foreign_key => :notification_category_id
  has_many :notifications, :class_name => 'Notification'
end
