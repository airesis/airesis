class AddEmailReceiptOption < ActiveRecord::Migration
  def up
    add_column :users, :receive_messages, :boolean, default: true, null: false
  end

  def down
    delete_column :users, :receive_messages
  end
end
