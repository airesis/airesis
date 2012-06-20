class Tag < ActiveRecord::Base
  
  has_many :proposal_tags, :class_name => 'ProposalTag'
  has_many :proposals, :through => :proposal_tags, :class_name => 'Proposal'
  
  
	def as_json(options={})    
   { :id => self.text, :name => self.text }
  end
end