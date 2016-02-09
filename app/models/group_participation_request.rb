class GroupParticipationRequest < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  belongs_to :status, class_name: 'GroupParticipationRequestStatus', foreign_key: :group_participation_request_status_id

  scope :pending, -> { where(group_participation_request_status_id: GroupParticipationRequestStatus::SENT) }
  scope :voting, -> { where(group_participation_request_status_id: GroupParticipationRequestStatus::VOTING) }

  validates_uniqueness_of :user_id, scope: :group_id

  after_commit :send_notifications, on: :create

  def pending?
    group_participation_request_status_id == GroupParticipationRequestStatus::SENT
  end

  protected

  def send_notifications
    NotificationParticipationRequestCreate.perform_async(id) if pending?
  end
end
