class AddMissingIndexes < ActiveRecord::Migration
  def up
    add_index :user_alerts, :checked
    add_index :user_alerts, :user_id
  end

  def down
    remove_index :user_alerts, :checked
    remove_index :user_alerts, :user_id
  end
end
