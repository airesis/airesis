class Tag < ActiveRecord::Base
  
  has_many :proposal_tags, :class_name => 'ProposalTag'
  has_many :proposals, :through => :proposal_tags, :class_name => 'Proposal'
  
  has_many :blog_post_tags, :class_name => 'BlogPostTag'
  has_many :blog_posts, :through => :blog_post_tags, :class_name => 'BlogPost'
  
  def as_json(options={})    
   { :id => self.text, :name => self.text }
  end
end
