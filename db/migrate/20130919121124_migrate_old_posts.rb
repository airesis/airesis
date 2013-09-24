class MigrateOldPosts < ActiveRecord::Migration
  def up
    BlogPost.all.each do |blog_post|
      blog_post.update_attribute(:body,blog_post.parsed_body)
    end
  end

  def down
    #can't go back from this
  end
end
