class RemoveOldTable < ActiveRecord::Migration
  def change
    drop_table :blog_post_images do |t|
      t.integer :blog_post_id
      t.integer :image_id
    end
  end
end
