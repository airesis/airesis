class RenameGroupImageUrl < ActiveRecord::Migration
  def change
    rename_column :groups, :image_url, :old_image_url
  end
end
