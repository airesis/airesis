class ImageGroups < ActiveRecord::Migration
  def up
    add_column :groups, :image_id, :integer
    add_column :groups, :title_bar, :string
  end

  def down
    remove_column :groups, :image_id
    remove_column :groups, :title_bar
  end
end
