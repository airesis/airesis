class CalculateRankings
  def perform(*_args)
    User.find_each do |user|
      # number of comments created
      numcommenti = user.proposal_comments.count
      # number of inserted proposals (excluded abandoned ones)
      numproposte = user.proposals.where('proposal_state_id in (?)', [1, 2, 3, 4]).count
      # number of accepted proposals
      numok = user.proposals.where(proposal_state_id: 6).count
      user.update_attribute(:rank, numcommenti + 2 * (numproposte) + 10 * (numok))
    end
  end
end
