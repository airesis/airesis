class BlockedAlert < ActiveRecord::Base
  belongs_to :user, :class_name => 'User', :foreign_key => :user_id
  belongs_to :notification_type, :class_name => 'NotificationType', :foreign_key => :notification_type_id
end
