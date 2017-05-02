require 'spec_helper'

describe ProposalVotationResult, type: :model do
  let(:user) { create(:user) }
  let(:proposal) { create(:in_vote_public_proposal, current_user_id: user.id, num_solutions: 5) }

  context 'verify schulze votation results' do
    def tie_expectations
      solutions = proposal.solutions.order(:id)
      expect(proposal.proposal_votation_result.beat_couples).to  eq ([])
      expect(proposal.proposal_votation_result.calculated).to eq false
      expect(proposal.proposal_votation_result.elements).to eq solutions.pluck(:id)
      expect(proposal.proposal_votation_result.limit).to eq SchulzeSolver::LIMIT
      expect(proposal.proposal_votation_result.ranks).to eq solutions.map{|s| [s.id, 0]}
      expect(proposal.proposal_votation_result.winners).to eq solutions.pluck(:id)
    end

    context 'no votes' do
      it 'persist data correctly' do
        proposal.close_vote_phase
        tie_expectations
      end
    end

    context 'one vote all the same is like no vote' do
      it 'persists data correctly' do
        create(:proposal_schulze_vote, proposal: proposal)
        proposal.close_vote_phase
        tie_expectations
      end
    end

    context 'one vote ordered by id' do
      it 'persists data correctly' do
        create(:proposal_schulze_vote_by_id, proposal: proposal)
        proposal.close_vote_phase
        solutions = proposal.solutions.order(:id)
        couples = []
        solutions.pluck(:id).each do |sol_id1|
          solutions.pluck(:id).each do |sol_id2|
            couples << [sol_id1, sol_id2] if sol_id1 < sol_id2
          end
        end
        expect(proposal.proposal_votation_result.beat_couples).to  eq (couples)
        expect(proposal.proposal_votation_result.calculated).to eq true
        expect(proposal.proposal_votation_result.elements).to eq solutions.pluck(:id)
        expect(proposal.proposal_votation_result.limit).to eq SchulzeSolver::LIMIT
        expect(proposal.proposal_votation_result.ranks).to eq solutions.reverse.each_with_index.map{|s, idx| [s.id, idx]}.reverse
        expect(proposal.proposal_votation_result.winners).to eq [solutions.pluck(:id).min]
      end
    end
  end
end
