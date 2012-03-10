class GroupPartecipation < ActiveRecord::Base
  belongs_to :user, :class_name => 'User', :foreign_key => :user_id
  belongs_to :partecipation_role, :class_name => 'PartecipationRole', :foreign_key => :partecipation_role_id
  belongs_to :group, :class_name => 'Group', :foreign_key => :group_id
end
