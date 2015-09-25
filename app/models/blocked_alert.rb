class BlockedAlert < ActiveRecord::Base
  belongs_to :user
  belongs_to :notification_type

  validates_uniqueness_of :user_id, scope: :notification_type_id, message: 'Notifica gia bloccata'
end
