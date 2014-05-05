class ProposalVote < ActiveRecord::Base
  belongs_to :proposal, class_name: 'Proposal', foreign_key: :proposal_id
  belongs_to :user, class_name: 'User', foreign_key: :user_id


  def number
    self.positive + self.negative + self.neutral
  end


  def positive_perc
    self.number > 0 ? ((self.positive.to_f / self.number.to_f) * 100).round(2) : 0
  end

  def negative_perc
    self.number > 0 ? ((self.negative.to_f / self.number.to_f) * 100).round(2) : 0
  end

  def neutral_perc
    self.number > 0 ? ((self.neutral.to_f / self.number.to_f) * 100).round(2) : 0
  end
end
