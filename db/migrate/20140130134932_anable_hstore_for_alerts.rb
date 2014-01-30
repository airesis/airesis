class AnableHstoreForAlerts < ActiveRecord::Migration
  def up
    execute "CREATE EXTENSION IF NOT EXISTS hstore"
    add_column :user_alerts, :properties, :hstore
    add_column :notifications, :properties, :hstore
    Notification.all.each do |notification|
      notification.properties = notification.data
      notification.save!
    end
  end

  def down
    execute "DROP EXTENSION IF NOT EXISTS hstore"
    remove_column :user_alerts, :properties
    remove_column :notifications, :properties
  end
end
