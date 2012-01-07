class BlogPostImage < ActiveRecord::Base
  belongs_to :image, :class_name => 'Image', :foreign_key => :image_id
  #has_one :partecipation_role, :class_name => 'PartecipationRole', :foreign_key => :partecipation_role_id
  belongs_to :blog_post, :class_name => 'BlogPost', :foreign_key => :blog_post_id
end
