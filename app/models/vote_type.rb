class VoteType < ActiveRecord::Base
  # translates :description

  # has_many :proposal_comment_rankings, class_name: 'ProposalCommentRanking'
  # has_many :proposal_rankings, class_name: 'ProposalRanking'

  POSITIVE = 1
  NEUTRAL = 2
  NEGATIVE = 3

  def description
    I18n.t("db.#{self.class.class_name.tableize}.#{short}.description")
  end
end
