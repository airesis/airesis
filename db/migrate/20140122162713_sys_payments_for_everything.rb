class SysPaymentsForEverything < ActiveRecord::Migration
  def up
    add_column :sys_payment_notifications, :payable_id, :integer
    add_column :sys_payment_notifications, :payable_type, :string

    SysPaymentNotification.all.each do |payment|
      payment.update_attributes({payable_type: 'SysFeature', payable_id: payment.sys_feature_id});
    end

    remove_column :sys_payment_notifications, :sys_feature_id
  end

  def down
    add_column :sys_payment_notifications, :sys_feature_id, :integer

    SysPaymentNotification.all.each do |payment|
      payment.update_attributes({sys_feature_id: payment.payable_id});
    end

    remove_column :sys_payment_notifications, :payable_type
    remove_column :sys_payment_notifications, :payable_id
  end
end
