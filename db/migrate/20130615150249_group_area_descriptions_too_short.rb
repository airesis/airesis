class GroupAreaDescriptionsTooShort < ActiveRecord::Migration
  def up
    change_column :group_areas, :description, :string, limit: 2000
  end

  def down
    change_column :group_areas, :description, :string, limit: 255
  end
end
