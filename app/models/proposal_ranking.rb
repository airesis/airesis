class ProposalRanking < ActiveRecord::Base
  belongs_to :ranking_type, :class_name => 'RankingType', :foreign_key => :ranking_type_id
  belongs_to :user, :class_name => 'User', :foreign_key => :user_id
  belongs_to :proposal, :class_name => 'Proposal', :foreign_key => :proposal_id, :counter_cache => true
  
  named_scope :positives, { :conditions => {:ranking_type_id => 1 }}
  named_scope :negatives, { :conditions => {:ranking_type_id => 3 }}
  
  
end
