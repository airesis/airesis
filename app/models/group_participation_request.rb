class GroupParticipationRequest < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  enum group_participation_request_status_id: { pending: 1, voting: 2, accepted: 3, rejected: 4 }

  validates_uniqueness_of :user_id, scope: :group_id

  after_commit :send_notifications, on: :create

  protected

  def send_notifications
    NotificationParticipationRequestCreate.perform_async(id) if pending?
  end
end
