class BlockedAlert < ApplicationRecord
  belongs_to :user, inverse_of: :blocked_alerts
  belongs_to :notification_type, inverse_of: :blocked_alerts

  validates :user_id, uniqueness: { scope: :notification_type_id }
end
