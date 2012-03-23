#encoding: utf-8
class ProposalHistory < ActiveRecord::Base
  include BlogKitModelHelper
    
  belongs_to :proposal, :class_name => 'Proposal', :foreign_key => :proposal_id
  belongs_to :user, :class_name => 'User', :foreign_key => :user_id
   
    
  def short_content
    return truncate_words(self.content,50)
  end
  
end
