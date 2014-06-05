class PostPublishing < ActiveRecord::Base
  belongs_to :blog_post, class_name: 'BlogPost', foreign_key: :blog_post_id
  #has_one :participation_role, class_name: 'ParticipationRole', foreign_key: :participation_role_id
  belongs_to :group, class_name: 'Group', foreign_key: :group_id

  scope :viewable_by, ->(user) { joins(blog_post: {groups: :group_participations}).includes(blog_post: [:blog, :tags, user: [:user_type, :image]]).where("blog_posts.status = 'P' or (blog_posts.status = 'R' and group_participations.user_id = ?)",user.id)}
end
