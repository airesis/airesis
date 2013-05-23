class SentFeedback < ActiveRecord::Base
  unloadable

  # Check for paperclip
  has_attached_file :image,
                    :url  => "/assets/images/feedback/:id/:basename.:extension",
                    :path => ":rails_root/public/assets/images/feedback/:id/:basename.:extension"

  validates_attachment_size :image, :less_than => 2.megabytes
  validates_attachment_content_type :image, :content_type => ['image/png']
end