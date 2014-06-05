class GroupParticipationRequest < ActiveRecord::Base
  include BlogKitModelHelper

  
  belongs_to :user, class_name: 'User', foreign_key: :user_id
  #has_one :participation_role, class_name: 'ParticipationRole', foreign_key: :participation_role_id
  belongs_to :group, class_name: 'Group', foreign_key: :group_id
  belongs_to :status, class_name: 'GroupParticipationRequestStatus', foreign_key: :group_participation_request_status_id
  
  scope :pending, -> { where(group_participation_request_status_id: 1)}
  scope :voting, -> {where(group_participation_request_status_id: 2)}
  
   validates_uniqueness_of :user_id, scope: :group_id
end
