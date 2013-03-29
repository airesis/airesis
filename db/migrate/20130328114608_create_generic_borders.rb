class CreateGenericBorders < ActiveRecord::Migration
  def up
    create_table :generic_borders do |t|
      t.string :description, limit: 255, null: false
      t.string :name, limit: 255, null: false
      t.integer :seq
    end
  end

  def down
    drop_table :generic_borders
  end
end
