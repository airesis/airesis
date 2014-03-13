class HiddenAlerts < ActiveRecord::Migration
  def up
    add_column :user_alerts, :deleted, :boolean, default: false, null: false
    add_column :user_alerts, :deleted_at, :timestamp
  end

  def down
    remove_column :user_alerts, :deleted
    remove_column :user_alerts, :deleted_at
  end
end
