class ProposalCommentRanking < ActiveRecord::Base
  belongs_to :user
  belongs_to :ranking_type
  belongs_to :proposal_comment

  scope :positives, -> { where(ranking_type_id: RankingType::POSITIVE) }
  scope :negatives, -> { where(ranking_type_id: RankingType::NEGATIVE) }
  scope :neutrals, -> { where(ranking_type_id: RankingType::NEUTRAL) }

  after_save :update_counter_cache
  after_destroy :update_counter_cache

  def update_counter_cache
    rankings = ProposalCommentRanking.where(proposal_comment_id: proposal_comment_id)
    nvalutations = rankings.count
    num_pos = rankings.positives.count
    num_neg = rankings.negatives.count
    ranking = 0
    res = num_pos.to_f / nvalutations.to_f
    ranking = res * 100 if nvalutations > 0
    j = num_pos + num_neg > 0 ? (num_pos.to_f - num_neg.to_f) / Math.sqrt(num_pos + num_neg) : 0
    proposal_comment.update_columns(valutations: nvalutations, rank: ranking.round, j_value: j.round(2))
  rescue Exception => e
    log_error(e)
  end
end
