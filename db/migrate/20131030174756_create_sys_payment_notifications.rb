class CreateSysPaymentNotifications < ActiveRecord::Migration
  def up
    create_table :sys_payment_notifications do |t|
      t.text :params
      t.integer :sys_feature_id
      t.string :status
      t.string :transaction_id

      t.timestamps
    end
  end


  def down
    drop_table :sys_payment_notifications
  end
end
