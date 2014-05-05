class CreateTutorialProgresses < ActiveRecord::Migration
  def up
    create_table :tutorial_progresses do |t|
      t.integer :user_id, null: false
      t.integer :step_id, null: false
      t.string :status, null: false, default: 'N'

      t.timestamps
    end
    
    add_foreign_key(:tutorial_progresses, :users)
    add_foreign_key(:tutorial_progresses, :steps)
  end
  
  def down
    drop_table :tutorial_progresses
  end
end
