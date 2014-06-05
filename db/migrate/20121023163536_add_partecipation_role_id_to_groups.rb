class AddParticipationRoleIdToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :participation_role_id, :integer, default: 1
    
    add_foreign_key(:groups,:participation_roles)
  end
end
