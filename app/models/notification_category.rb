class NotificationCategory < ApplicationRecord
  has_many :notification_types, -> { order('id') }

  def description
    I18n.t("db.#{self.class.class_name.tableize}.#{short}.description")
  end
end
