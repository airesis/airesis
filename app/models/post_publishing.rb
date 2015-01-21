class PostPublishing < ActiveRecord::Base
  belongs_to :blog_post, class_name: 'BlogPost', foreign_key: :blog_post_id, inverse_of: :publishings
  belongs_to :group, class_name: 'Group', foreign_key: :group_id, inverse_of: :post_publishings

  scope :viewable_by, ->(user) { joins(blog_post: {groups: :group_participations}).where("blog_posts.status = 'P' or (blog_posts.status = 'R' and group_participations.user_id = ?)", user.try(:id) || -1) }
end
