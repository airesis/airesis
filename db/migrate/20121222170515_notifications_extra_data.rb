class NotificationsExtraData < ActiveRecord::Migration
  def up
    #dati aggiuntivi alle notifiche
    create_table :notification_data do |t|
      t.integer :notification_id, null: false
      t.string :name, null: false, limit: 100
      t.string :value, null: true, limit: 4000
    end
    
    add_foreign_key(:notification_data,:notifications)
    add_index :notification_data, [:notification_id,:name], unique: true
  end
  
  def down
    drop_table :notification_data
  end
end
