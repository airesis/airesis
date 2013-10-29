class GroupsPolicy < ActiveRecord::Migration
  def up
    add_column :groups, :status, :string, null: false, default: 'active'
    add_column :groups, :status_changed_at, :timestamp
  end

  def down
    remove_column :groups, :status
    remove_column :groups, :status_changed_at
  end
end
