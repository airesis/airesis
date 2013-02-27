class ProposalCommentRanking < ActiveRecord::Base
  belongs_to :user, :class_name => 'User', :foreign_key => :user_id
  belongs_to :ranking_type, :class_name => 'RankingType', :foreign_key => :ranking_type_id
  belongs_to :proposal_comment, :class_name => 'ProposalComment', :foreign_key => :proposal_comment_id
  
  
  scope :positives, { :conditions => {:ranking_type_id => POSITIVE_VALUTATION }}
  scope :negatives, { :conditions => {:ranking_type_id => NEGATIVE_VALUTATION }}

  after_save :update_counter_cache
  after_destroy :update_counter_cache

  def update_counter_cache
    nvalutations = ProposalCommentRanking.count(:conditions => ["proposal_comment_id = ?",self.proposal_comment.id])
    num_pos = ProposalCommentRanking.count(:conditions => ["proposal_comment_id = ? AND ranking_type_id = ?",self.proposal_comment.id,POSITIVE_VALUTATION])
    num_neg = ProposalCommentRanking.count(:conditions => ["proposal_comment_id = ? AND ranking_type_id = ?",self.proposal_comment.id,NEGATIVE_VALUTATION])
    ranking = 0
    res = num_pos.to_f / nvalutations.to_f
    ranking = res*100 if nvalutations > 0
    j = num_pos+num_neg > 0 ? ((num_pos.to_f - num_neg.to_f)**2)/(num_pos+num_neg) : 0
    #TODO sostituire con update_columns quando sarà disponibile
    self.proposal_comment.update_column(:valutations,nvalutations)
    self.proposal_comment.update_column(:rank,ranking.round)
    self.proposal_comment.update_column(:j_value,j.round(2))
    
  rescue Exception => e
    puts e
  end
  
end
