class Blog < ActiveRecord::Base
  belongs_to :user, :class_name => 'User', :foreign_key => :user_id
  has_many :posts, :class_name => 'BlogPost', :dependent => :destroy
#  has_many :blog_tags, :dependent => :destroy
  
#  before_save :save_tags, :if => :not_resaving?
#  
#  def tags
#    @tags ||= self.blog_tags.map(&:tag).join(', ')
#  end
#  
#  def tags=(tags)
#    @tags = tags
#  end
#
#  def tags_with_links
#    html = self.tags.split(/,/).collect {|t| "<a href=\"/blogs/tag/#{t.strip}\">#{t.strip}</a>" }.join(', ')
#    return html
#  end
#  
#  def save_tags
#    if @tags
#      # Remove old tags
#      self.blog_tags.delete_all
#    
#      # Save new tags
#      @tags.split(/,/).each do |tag|
#        self.blog_tags.build(:tag => tag.strip.downcase)
#      end
#    end
#  end
#  
#  def not_resaving?
#    !@resaving
#  end
end
