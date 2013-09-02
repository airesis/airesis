class BlogPostTag < ActiveRecord::Base
	unloadable

	belongs_to :blog_post
	belongs_to :tag

  after_create  :increment_counter_cache
  after_destroy :decrement_counter_cache

  private
  def decrement_counter_cache
    tag.blog_posts_count = tag.blog_posts_count - 1
    tag.save
  end

  def increment_counter_cache
    tag.blog_posts_count = tag.blog_posts_count + 1
    tag.save
  end

end