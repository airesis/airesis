class ProposalVote < ActiveRecord::Base
  belongs_to :proposal, :class_name => 'Proposal', :foreign_key => :proposal_id
  belongs_to :user, :class_name => 'User', :foreign_key => :user_id


  def number
    self.positive + self.negative + self.neutral
  end


  def positive_perc
    ((self.positive.to_f / self.number.to_f) * 100).round(2)
  end

  def negative_perc
    ((self.negative.to_f / self.number.to_f) * 100).round(2)
  end

  def neutral_perc
    ((self.neutral.to_f / self.number.to_f) * 100).round(2)
  end
end
