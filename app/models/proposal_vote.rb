class ProposalVote < ActiveRecord::Base
  belongs_to :proposal

  def number
    valuables + neutral
  end

  def positive_perc
    perc(positive)
  end

  def negative_perc
    perc(negative)
  end

  def neutral_perc
    perc(neutral)
  end

  def valuables
    positive + negative
  end

  # returns true if there was at least one vote
  def any_vote?
    number > 0
  end

  def any_valuable_vote?
    valuables > 0
  end

  def positive_perc_over_valuable
    positive.to_f / valuables.to_f
  end

  protected

  def perc(value)
    number > 0 ? ((value.to_f / number) * 100).round(2) : 0
  end
end
