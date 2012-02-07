class LastOneMaybe < ActiveRecord::Migration
  def up
    add_column :groups, :image_url, :string
  end

  def down
    remove_column :groups, :image_url
  end
end
