class RankingType < ActiveRecord::Base
  #has_many :proposal_comment_rankings, class_name: 'ProposalCommentRanking'
  #has_many :proposal_rankings, class_name: 'ProposalRanking'

  POSITIVE = 1
  NEUTRAL = 2
  NEGATIVE = 3


  def description
    case id
      when POSITIVE
        I18n.t('pages.proposals.show.voteup')
      when NEUTRAL
        I18n.t('pages.proposals.show.votenil')
      when NEGATIVE
        I18n.t('pages.proposals.show.votedown')
      else
        ''
    end
  end
end
