class Announcement < ActiveRecord::Base
  validates :messages, presence: true
  validates :starts_at, presence: true
  validates :ends_at, presence: true

  def self.current(hidden_ids = nil)
    result = where('starts_at <= :now and ends_at >= :now', now: Time.zone.now)
    result = result.where('id not in (?)', hidden_ids) if hidden_ids.present?
    result
  end
end
