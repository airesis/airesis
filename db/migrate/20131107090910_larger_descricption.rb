class LargerDescricption < ActiveRecord::Migration
  def up
    change_column :sys_features, :description, :string, limit: 40000
    add_attachment :sys_features, :image
  end

  def down
  end
end
