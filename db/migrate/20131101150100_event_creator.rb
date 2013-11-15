class EventCreator < ActiveRecord::Migration
  def up
    add_column :events, :user_id, :integer
    add_foreign_key :events, :users
  end

  def down
    remove_column :events, :user_id
  end
end
