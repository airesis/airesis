class AddPrivateColumnToEvents < ActiveRecord::Migration
  def up
    add_column :events, :private, :boolean, :default => false, :null => false
  end
  
  def down
    drop_column :proposals, :private
  end
end
