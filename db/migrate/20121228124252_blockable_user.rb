class BlockableUser < ActiveRecord::Migration
  def up
    add_column :users, :blocked, :boolean, :default => false
  end

  def down
    remove_column :users, :blocked
  end
end
