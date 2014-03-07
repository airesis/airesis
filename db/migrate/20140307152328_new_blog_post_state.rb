class NewBlogPostState < ActiveRecord::Migration
  def up
    add_column :blog_posts, :status, :string, limit: 1, null: false, default: 'P'
    BlogPost.all.each do |blog_post|
      blog_post.update_attribute(:status, blog_post.published ? 'P': 'D')
    end
  end

  def down
    remove_column :blog_posts, :status
  end
end
