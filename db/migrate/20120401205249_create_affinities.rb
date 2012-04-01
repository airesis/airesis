class CreateAffinities < ActiveRecord::Migration
  def up
    create_table :group_affinities do |t|
      t.integer :group_id, :null => false
      t.integer :user_id, :null => false
      t.integer :value
      t.boolean :recalculate, :default => false      
      t.timestamps
    end
    add_foreign_key(:group_affinities, :users)
    add_foreign_key(:group_affinities, :groups)
  end

  def down
    drop_table :group_affinities
  end
end
