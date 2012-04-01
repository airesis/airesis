class CreateSteps < ActiveRecord::Migration
  def up
    create_table :steps do |t|
      t.integer :tutorial_id, :null => false
      t.integer :index, :null => false, :default => 0
      t.string :title, :limit => 255
      t.text :content
      t.boolean :required, :default => false
      t.text :fragment
      t.timestamps
    end
  
   add_foreign_key(:steps, :tutorials)
  end
  
  def down
    drop_table :steps
  end
end
