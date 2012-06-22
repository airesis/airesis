class RecoverPassword < ActiveRecord::Migration
  def up
    add_column :users, :reset_password_sent_at, :timestamp
  end

  def down
    drop_column :users, :reset_password_sent_at
  end
end
