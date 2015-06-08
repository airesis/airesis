class TagCounter < ActiveRecord::Base
  belongs_to :tag
  belongs_to :territory, polymorphic: true

  validates :tag, presence: true
  validates :territory, presence: true

  scope :most_used, ->(limit=10) {
    where('(blog_posts_count + blogs_count + proposals_count + groups_count) > ?', limit).order('random()') }
  scope :most_groups, ->(limit=40) {
    where('groups_count > 0').order('groups_count desc').limit(limit) }
  scope :most_blogs, ->(limit=40) {
    where('blog_posts_count > 0').order('blog_posts_count desc').limit(limit) } # TODO: use blog_post for now
end
