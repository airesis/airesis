class ProposalCommentRanking < ActiveRecord::Base
  belongs_to :user, class_name: 'User', foreign_key: :user_id
  belongs_to :ranking_type, class_name: 'RankingType', foreign_key: :ranking_type_id
  belongs_to :proposal_comment, class_name: 'ProposalComment', foreign_key: :proposal_comment_id


  scope :positives, -> { where(ranking_type_id: RankingType::POSITIVE) }
  scope :negatives, -> { where(ranking_type_id: RankingType::NEGATIVE) }
  scope :neutrals, -> { where(ranking_type_id: RankingType::NEUTRAL) }

  after_save :update_counter_cache
  after_destroy :update_counter_cache

  def update_counter_cache
    rankings = ProposalCommentRanking.where(["proposal_comment_id = ?", self.proposal_comment.id])
    nvalutations = rankings.count
    num_pos = rankings.positives.count
    num_neg = rankings.negatives.count
    ranking = 0
    res = num_pos.to_f / nvalutations.to_f
    ranking = res*100 if nvalutations > 0
    j = num_pos+num_neg > 0 ? (num_pos.to_f - num_neg.to_f)/Math.sqrt(num_pos+num_neg) : 0
    self.proposal_comment.update_columns({valutations: nvalutations, rank: ranking.round, j_value: j.round(2)})
  rescue Exception => e
    log_error(e)
  end

end
