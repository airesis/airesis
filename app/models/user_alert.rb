class UserAlert < ActiveRecord::Base
  belongs_to :user, :class_name => 'User', :foreign_key => :user_id
  belongs_to :notification, :class_name => 'Notification', :foreign_key => :notification_id

  def email_subject
    subject = self.notification.data[:group] ? "[#{self.notification.data[:group]}] " : ''
    subject += I18n.t("db.notification_types.#{self.notification.notification_type.name}.email_subject", self.notification.data)
  end
end
