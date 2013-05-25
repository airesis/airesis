class VoteType < ActiveRecord::Base
  translates :description

  #has_many :proposal_comment_rankings, :class_name => 'ProposalCommentRanking'
  #has_many :proposal_rankings, :class_name => 'ProposalRanking'
end
