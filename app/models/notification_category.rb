class NotificationCategory < ActiveRecord::Base
#  translates :description
  has_many :notification_types, :class_name => 'NotificationType', :order => :id

  def description
    I18n.t("db.#{self.class.class_name.tableize}.#{self.short}.description")
  end
end
