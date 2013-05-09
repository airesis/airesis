class RankingType < ActiveRecord::Base
  #has_many :proposal_comment_rankings, :class_name => 'ProposalCommentRanking'
  #has_many :proposal_rankings, :class_name => 'ProposalRanking'

  POSITIVE = 1
  NEUTRAL = 2
  NEGATIVE = 3
end
