class AddFieldsForBlock < ActiveRecord::Migration
  def up
    add_column :users, :blocked_name, :string, limit: 255
    add_column :users, :blocked_surname, :string, limit: 255
  end

  def down
    remove_column :users, :blocked_name
    remove_column :users, :blocked_surname
  end
end
