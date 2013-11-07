class OtherNotificationColumns < ActiveRecord::Migration
  def up
    add_column :sys_payment_notifications, :payment_fee, :decimal
    add_column :sys_payment_notifications, :payment_gross, :decimal
    add_column :sys_payment_notifications, :first_name, :string, limit:4000
    add_column :sys_payment_notifications, :last_name, :string, limit:4000
  end

  def down
    remove_column :sys_payment_notifications, :payment_fee
    remove_column :sys_payment_notifications, :payment_gross
    remove_column :sys_payment_notifications, :first_name
    remove_column :sys_payment_notifications, :last_name
  end
end
