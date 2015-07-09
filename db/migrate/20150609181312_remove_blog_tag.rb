class RemoveBlogTag < ActiveRecord::Migration
  def change
    drop_table :blog_tags
  end
end
