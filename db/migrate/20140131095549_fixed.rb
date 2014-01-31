class Fixed < ActiveRecord::Migration
  def change
    change_column :user_alerts, :properties, :hstore, default: '', null: false
    change_column :notifications, :properties, :hstore, default: '', null: false
  end
end
