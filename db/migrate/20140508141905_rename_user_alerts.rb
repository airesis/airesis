class RenameUserAlerts < ActiveRecord::Migration
  def change
    rename_table :user_alerts, :alerts
  end
end
