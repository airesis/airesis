# assign a tag to a blog post.
class BlogPostTag < ActiveRecord::Base

  belongs_to :blog_post
  belongs_to :tag

  after_create :increment_counter_cache
  after_destroy :decrement_counter_cache

  protected

  def decrement_counter_cache

    increment_counter_cache(-1)
  end

  def increment_counter_cache(n = 1)
    territory = blog_post.user.original_locale.territory
    tag.tag_counters.find_or_create_by(territory: territory) do |tag_counter|
      tag_counter.blog_posts_count = tag_counter.blog_posts_count + n
    end
  end
end
