class Notification < ActiveRecord::Base
  belongs_to :notification_type, :class_name => 'NotificationType', :foreign_key => :notification_type_id
end
