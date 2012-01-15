class NotificationsLinks < ActiveRecord::Migration
  def up
    add_column :notifications, :url, :string
  end

  def down
    remove_column :notifications, :url, :string
   
  end
end
