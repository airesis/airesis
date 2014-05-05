class CreateTutorials < ActiveRecord::Migration
  def up
    create_table :tutorials do |t|
      t.string :action
      t.string :controller, null: false
      t.string :name, limit: 255
      t.text :description, null: false

      t.timestamps
    end
  end
  
  def down
    drop_table :tutorials
  end
end
