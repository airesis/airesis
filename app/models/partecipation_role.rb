class PartecipationRole < ActiveRecord::Base
  has_many :groups_partecipations, :class_name => 'GroupsPartecipation'
  belongs_to :partecipation_roles, :class_name => 'PartecipationRole', :foreign_key => :parent_partecipation_role_id
  belongs_to :groups, :class_name => 'Group', :foreign_key => :group_id
end
