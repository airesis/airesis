#todo to remove
class Image < ActiveRecord::Base


  attr_accessor :random_id
  
  # Check for paperclip
  has_attached_file :image,
              		  styles: {
                      :thumb=> "100x100#",
                      :small  => "150x150>"
                    },
                    :url  => "/assets/images/users/:id/:style/:basename.:extension",
                    path: ":rails_root/public/assets/images/users/:id/:style/:basename.:extension"
  
  validates_attachment_presence :image
  validates_attachment_size :image, less_than: 2.megabytes
  validates_attachment_content_type :image, content_type: ['image/jpeg', 'image/png']
end