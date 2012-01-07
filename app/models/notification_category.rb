class NotificationCategory < ActiveRecord::Base
  has_many :notification_types, :class_name => 'NotificationType'
end
