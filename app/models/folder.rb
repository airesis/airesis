class Folder < ActiveRecord::Base

  #has_many :blog_posts, through: :blog_post_images, dependent: :destroy

  #attr_accessor :random_id
  belongs_to :group
  
  # Check for paperclip
  has_attached_file :file,
                    #:url  => ":rails_root/private/:group_id/:id/:basename.:extension",
                    path: ":rails_root/private/groups/:group_id/:class/:id/:basename.:extension"
  
  validates_attachment_presence :file
  validates_attachment_size :file, less_than: 5.megabytes
  #validates_attachment_content_type :image, content_type: ['image/jpeg', 'image/png']
end