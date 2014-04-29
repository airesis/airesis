class AddTimestampsToBlog < ActiveRecord::Migration
  def up
    add_column :blogs, :created_at, :datetime
    add_column :blogs, :updated_at, :datetime

    Blog.all.each do |blog|
      blog.created_at = blog.user.created_at
      blog.updated_at = blog.last_post.try(:updated_at) || blog.created_at
    end
  end

  def down
    remove_column :blogs, :created_at
    remove_column :blogs, :updated_at
  end
end
