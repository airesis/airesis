class MeetingParticipation < ActiveRecord::Base
  include BlogKitModelHelper

  belongs_to :user, class_name: 'User', foreign_key: :user_id
  belongs_to :meeting, class_name: 'Meeting', foreign_key: :meeting_id

  delegate :event, to: :meeting

  validates :user_id, presence: true
  validates :user, uniqueness: {scope: :meeting}
  validates :meeting, presence: true
  validates :guests, presence: true
  validates :response, presence: true

  validates :comment, length: {maximum: 255}

  def will_come?
    self.response == 'Y'
  end
end
