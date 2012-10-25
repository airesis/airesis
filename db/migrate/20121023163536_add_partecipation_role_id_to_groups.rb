class AddPartecipationRoleIdToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :partecipation_role_id, :integer, :default => 1
    
    add_foreign_key(:groups,:partecipation_roles)
  end
end
