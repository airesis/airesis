class ActionAbilitation < ActiveRecord::Base
  belongs_to :group_action, :class_name => 'GroupAction', :foreign_key => :group_action_id  
  belongs_to :partecipation_role, :class_name => 'PartecipationRole', :foreign_key => :partecipation_role_id
  belongs_to :group, :class_name => 'Group', :foreign_key => :group_id
end
