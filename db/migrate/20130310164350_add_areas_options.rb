class AddAreasOptions < ActiveRecord::Migration
  def up
    Configuration.create(name: 'group_areas', value: 1)
    add_column :groups, :enable_areas, :boolean, null: false, default: false
  end

  def down
    Configuration.find_by_name('group_areas').destroy
    remove_column :groups, :enable_areas
  end
end
