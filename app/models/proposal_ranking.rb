#encoding: utf-8
class ProposalRanking < ActiveRecord::Base
  belongs_to :ranking_type
  belongs_to :user
  belongs_to :proposal

  POSITIVE = 1
  NEGATIVE = 3

  scope :positives, -> { where(ranking_type_id: POSITIVE) }
  scope :negatives, -> { where(ranking_type_id: NEGATIVE) }

  after_save :update_counter_cache
  after_destroy :update_counter_cache

  def update_counter_cache
    rankings = proposal.rankings
    nvalutations = rankings.count
    num_pos = rankings.where(ranking_type_id: POSITIVE).count
    res = num_pos.to_f / nvalutations.to_f
    ranking = nvalutations > 0 ? res*100 : 0
    proposal.update_columns(valutations: nvalutations, rank: ranking.round)
    proposal.check_phase
  end
end
