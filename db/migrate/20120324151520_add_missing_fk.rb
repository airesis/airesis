class AddMissingFk < ActiveRecord::Migration
  def up
    add_foreign_key(:action_abilitations, :group_actions)
    add_foreign_key(:action_abilitations, :participation_roles)
  end

  def down
    
  end
end
