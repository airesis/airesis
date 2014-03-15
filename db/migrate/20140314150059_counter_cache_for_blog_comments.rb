class CounterCacheForBlogComments < ActiveRecord::Migration
  def up
    add_column :blog_posts, :blog_comments_count, :integer, null: false, default: 0

    BlogPost.all.each do |b|
      BlogPost.reset_counters(b.id, :blog_comments)
    end
  end

  def down
    remove_column :blog_posts, :blog_comments_count
  end
end
