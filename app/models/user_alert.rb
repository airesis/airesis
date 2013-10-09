class UserAlert < ActiveRecord::Base
  belongs_to :user, :class_name => 'User', :foreign_key => :user_id
  belongs_to :notification, :class_name => 'Notification', :foreign_key => :notification_id

  def email_subject
    self.notification.email_subject
  end
end
