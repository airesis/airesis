class NotificationCategory < ActiveRecord::Base
#  translates :description
  has_many :notification_types, -> {order('id')}, class_name: 'NotificationType'

  def description
    I18n.t("db.#{self.class.class_name.tableize}.#{self.short}.description")
  end
end
