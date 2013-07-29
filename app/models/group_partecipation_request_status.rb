class GroupPartecipationRequestStatus < ActiveRecord::Base
  SENT=1
  VOTING=2
  ACCEPTED=3
  REJECTED=4

  has_many :group_partecipation_requests, :class_name => 'GroupPartecipationRequests'
  
end
