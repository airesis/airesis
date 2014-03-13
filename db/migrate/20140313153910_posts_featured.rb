class PostsFeatured < ActiveRecord::Migration
  def up
    add_column :post_publishings, :featured, :boolean, null: false, default: false
  end

  def down
    remove_column :post_publishings, :featured
  end
end
