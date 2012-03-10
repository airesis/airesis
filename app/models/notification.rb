class Notification < ActiveRecord::Base
  belongs_to :notification_type, :class_name => 'NotificationType', :foreign_key => :notification_type_id
  has_many :user_alerts, :class_name => "UserAlert", :dependent => :destroy
end
