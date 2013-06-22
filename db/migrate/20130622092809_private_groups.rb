class PrivateGroups < ActiveRecord::Migration
  def up
    add_column :groups, :private, :boolean, default: false
  end

  def down
    remove_column :groups, :private
  end
end
