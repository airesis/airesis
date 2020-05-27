class BlockedEmail < ApplicationRecord
  validates :user_id, uniqueness: { scope: :notification_type_id, message: 'Notifica gia bloccata' }

  belongs_to :user, class_name: 'User', foreign_key: :user_id
  belongs_to :notification_type, class_name: 'NotificationType', foreign_key: :notification_type_id
end
