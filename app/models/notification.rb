class Notification < ApplicationRecord
  belongs_to :notification_type
  has_many :alerts, dependent: :destroy
  has_many :notification_data, class_name: 'NotificationData', dependent: :destroy, foreign_key: :notification_id

  def data
    ret = properties.symbolize_keys
    ret[:count] = ret[:count].to_i
    ret
  end

  def data=(data)
    self.properties = data
  end

  def message_interpolation
    extension = ".#{data[:extension]}" if data[:extension]
    "db.notification_types.#{notification_type.name}.message#{extension}"
  end

  def email_subject_interpolation
    extension = ".#{data[:extension]}" if data[:extension]
    "db.notification_types.#{notification_type.name}.email_subject#{extension}"
  end
end
