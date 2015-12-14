require 'spec_helper'

describe ProposalVotationResult, type: :model do
  let(:user) { create(:user) }
  let(:proposal) { create(:in_vote_public_proposal, current_user_id: user.id, num_solutions: 5) }

  context 'verify schulze votation results' do
    context 'no votes' do
      it 'persist data correctly' do
        proposal.close_vote_phase
        expect(proposal.proposal_votation_result.data).to be {}
      end
    end
  end
end
