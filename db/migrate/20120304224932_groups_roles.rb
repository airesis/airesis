class GroupsRoles < ActiveRecord::Migration
  def up
    create_table :group_actions do |t|
      t.string :name
      t.text :description
      t.timestamps
    end
    
    create_table :action_abilitations do |t|
      t.references :group_action
      t.references :participation_role
      t.references :group
      t.timestamps
    end
  end

  def down
    drop_table :group_actions
    drop_table :action_abilitations
  end
end
