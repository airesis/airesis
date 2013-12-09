class CalculateGroupStatistics
  
  def self.perform(*args)
    Group.all.each do |group|
      statistic = group.statistic
      proposals = group.internal_proposals.where("proposal_state_id not in (#{ProposalState::VALUTATION})") #take all group proposals currently not in debate
      statistic.valutations = proposals.average('valutations')
      statistic.good_score = proposals.average('rank')
      vote_participants = 0
      count = 0
      proposals = group.internal_proposals.voted.each do |proposal| #take all group proposals voted (accepted or rejected)
        vote_participants += proposal.is_schulze? ? proposal.schulze_votes.sum(:count) : proposal.vote.number
        count += 1
      end
      statistic.vote_valutations = count > 0 ? vote_participants.to_f / count.to_f : 0
      statistic.save!
    end
  end

end
