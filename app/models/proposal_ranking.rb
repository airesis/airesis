#encoding: utf-8
class ProposalRanking < ActiveRecord::Base
  belongs_to :ranking_type, :class_name => 'RankingType', :foreign_key => :ranking_type_id
  belongs_to :user, :class_name => 'User', :foreign_key => :user_id
  belongs_to :proposal, :class_name => 'Proposal', :foreign_key => :proposal_id

  scope :positives, { :conditions => {:ranking_type_id => 1 }}
  scope :negatives, { :conditions => {:ranking_type_id => 3 }}
  
  after_save :update_counter_cache
  after_destroy :update_counter_cache

  def update_counter_cache
    nvalutations = ProposalRanking.count(:conditions => ["proposal_id = ?",self.proposal.id])
    num_pos = ProposalRanking.count(:conditions => ["proposal_id = ? AND ranking_type_id = ?",self.proposal.id,1])
    ranking = 0
    res = num_pos.to_f / nvalutations.to_f
    ranking = res*100 if nvalutations > 0    
    #TODO sostituire con update_columns quando sarà disponibile
    self.proposal.update_column(:valutations,nvalutations)
    self.proposal.update_column(:rank,ranking.round)
    
  rescue Exception => e
    puts e
  end

end
