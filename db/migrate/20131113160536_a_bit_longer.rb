class ABitLonger < ActiveRecord::Migration
  def up
    change_column :groups, :description, :string, :limit => 2500
  end

  def down
    change_column :groups, :description, :string, :limit => 2000
  end
end
