class CreateSysPaymentNotifications < ActiveRecord::Migration
  def up
    create_table :sys_payment_notifications do |t|
      t.text :params
      t.integer :sys_feature_id
      t.string :status
      t.string :transaction_id

      t.timestamps
    end

    add_index :sys_payment_notifications, :transaction_id, unique: true
    add_foreign_key :sys_payment_notifications, :sys_features
  end


  def down
    drop_table :sys_payment_notifications
  end
end
