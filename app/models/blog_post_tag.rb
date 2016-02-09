# assign a tag to a blog post.
class BlogPostTag < ActiveRecord::Base
  belongs_to :blog_post
  belongs_to :tag

  after_create :increment_counter_cache
  after_destroy :decrement_counter_cache

  protected

  def decrement_counter_cache
    territory = blog_post.user.original_locale.territory
    tag_counter = tag.tag_counters.find_or_create_by(territory: territory)
    tag_counter.decrement!(:blog_posts_count)
  end

  def increment_counter_cache
    territory = blog_post.user.original_locale.territory
    tag_counter = tag.tag_counters.find_or_create_by(territory: territory)
    tag_counter.increment!(:blog_posts_count)
  end
end
