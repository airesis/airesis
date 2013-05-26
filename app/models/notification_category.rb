class NotificationCategory < ActiveRecord::Base
  translates :description
  has_many :notification_types, :class_name => 'NotificationType', :order => :id
end
