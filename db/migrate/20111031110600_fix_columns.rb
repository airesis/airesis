class FixColumns < ActiveRecord::Migration
  def self.up
     change_column :users, "user_type_id", :integer, :default => 3, :null => false
     change_column :users, "sign_in_count", :integer, :default => 0, :null => false
     change_column :users, "rank", :integer, :default => 0, :null => false
  end

  def self.down
  end
end
