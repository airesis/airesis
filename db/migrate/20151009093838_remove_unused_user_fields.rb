class RemoveUnusedUserFields < ActiveRecord::Migration
  def change
    remove_column :users, :residenza_id, :integer
    remove_column :users, :nascita_id, :integer
    remove_column :users, :activist, :boolean
    remove_column :users, :elected, :boolean
  end
end
