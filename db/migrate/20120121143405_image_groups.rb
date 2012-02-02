class ImageGroups < ActiveRecord::Migration
  def up
    add_column :groups, :image_id, :integer
    add_column :groups, :title_bar, :string
    add_column :places, :latitude_center, :float
    add_column :places, :longitude_center, :float
    add_column :places, :zoom, :integer    
    remove_column :places, :latitude_calculated
    remove_column :places, :longitude_calculated
  end

  def down
    remove_column :groups, :image_id
    remove_column :groups, :title_bar
    remove_column :places, :latitude_center
    remove_column :places, :longitude_center
    remove_column :places, :zoom
    add_column :places, :latitude_calculated
    add_column :places, :longitude_calculated
    
  end
end
