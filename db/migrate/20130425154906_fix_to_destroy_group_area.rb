class FixToDestroyGroupArea < ActiveRecord::Migration
  def up
    change_column :group_areas, :area_role_id, :integer, null: true
  end

  def down
  end
end
