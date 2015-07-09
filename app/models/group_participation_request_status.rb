class GroupParticipationRequestStatus < ActiveRecord::Base

  SENT=1
  VOTING=2
  ACCEPTED=3
  REJECTED=4

  has_many :group_participation_requests, class_name: 'GroupParticipationRequests'

  def self.active
    where(['id != ?', VOTING])
  end

end
