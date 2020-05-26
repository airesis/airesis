class NotificationData < ApplicationRecord
  belongs_to :notification, class_name: 'Notification', foreign_key: :notification_id
end
