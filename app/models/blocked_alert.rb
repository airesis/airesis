#encoding: utf-8
class BlockedAlert < ActiveRecord::Base

  validates_uniqueness_of :user_id, scope: :notification_type_id, message: 'Notifica gia bloccata'

  belongs_to :user, class_name: 'User', foreign_key: :user_id
  belongs_to :notification_type, class_name: 'NotificationType', foreign_key: :notification_type_id

end
