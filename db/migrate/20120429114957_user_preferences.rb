class UserPreferences < ActiveRecord::Migration
  def up
    add_column :users, :email_alerts, :boolean, :default => false, :null => false
  end

  def down
    drop_column :users, :email_alerts
  end
end
