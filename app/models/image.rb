class Image < ActiveRecord::Base	
  unloadable
  
  has_many :blog_posts, :through => :blog_post_images, :dependent => :destroy

  attr_accessor :random_id
  
  # Check for paperclip
  has_attached_file(:image, 
              			  :styles => {
                        :thumb=> "100x100#",
                        :small  => "150x150>"
  },
                      :url  => "/assets/users/:id/:style/:basename.:extension",
                      :path => ":rails_root/app/assets/images/users/:id/:style/:basename.:extension")
  
  validates_attachment_presence :image
  validates_attachment_size :image, :less_than => 5.megabytes
  validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png']                  
end