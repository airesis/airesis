class CreateTutorialAssignees < ActiveRecord::Migration
  def up
    create_table :tutorial_assignees do |t|
      t.integer :user_id, :null => false
      t.integer :tutorial_id, :null => false
      t.boolean :completed, :null => false, :default => false
      t.integer :index, :null => false, :default => 0

      t.timestamps
    end
    
    add_foreign_key(:tutorial_assignees, :users)
    add_foreign_key(:tutorial_assignees, :tutorials)
  end
  
  def down
    drop_table :tutorial_assignees
  end
end
