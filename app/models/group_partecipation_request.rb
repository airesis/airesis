class GroupPartecipationRequest < ActiveRecord::Base
  include BlogKitModelHelper

  
  belongs_to :user, :class_name => 'User', :foreign_key => :user_id
  #has_one :partecipation_role, :class_name => 'PartecipationRole', :foreign_key => :partecipation_role_id
  belongs_to :group, :class_name => 'Group', :foreign_key => :group_id
  belongs_to :status, :class_name => 'GroupPartecipationRequestStatus', :foreign_key => :group_partecipation_request_status_id
  
  scope :pending, { :conditions => {:group_partecipation_request_status_id => 1 }}
  scope :voting, { :conditions => {:group_partecipation_request_status_id => 2 }}
  
   validates_uniqueness_of :user_id, :scope => :group_id
end
