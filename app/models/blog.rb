class Blog < ActiveRecord::Base
  include BlogKitModelHelper

  belongs_to :user, :class_name => 'User', :foreign_key => :user_id
  has_many :posts, :class_name => 'BlogPost', :dependent => :destroy
  has_many :comments, :through => :posts, source: :blog_comments
  
  has_many :blog_tags, :dependent => :destroy
  has_many :tags, :through => :blog_tags, :class_name => 'Tag'



  def to_param
    "#{id}-#{title.downcase.gsub(/[^a-zA-Z0-9]+/, '-').gsub(/-{2,}/, '-').gsub(/^-|-$/, '')}"
  end

  searchable do
    text :title, boost: 2
    text :fullname do
      self.user.fullname
    end
  end
end
