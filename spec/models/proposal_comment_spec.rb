require 'rails_helper'

describe ProposalComment, type: :model, seeds: true do
  let(:user) { create(:user) }
  let(:proposal) { create(:public_proposal, current_user_id: user.id) }

  before(:each) do
    load_municipalities
    proposal
  end

  context 'contributes count' do
    context 'when a contribute is added' do
      let!(:contribute) { create(:proposal_comment, proposal: proposal) }
      before(:each) do
        proposal.reload
      end
      it 'increases the number of comments of the proposal' do
        expect(proposal.proposal_comments_count).to eq 1
      end

      it 'increases the number of contributes of the proposal' do
        expect(proposal.proposal_contributes_count).to eq 1
      end
      context 'when a comment is added' do
        let!(:comment) { create(:proposal_comment, contribute: contribute, proposal: proposal) }
        before(:each) do
          proposal.reload
        end
        it 'increases the number of comments of the proposal' do
          expect(proposal.proposal_comments_count).to eq 2
        end

        it 'does not increase the number of contributes of the proposal' do
          expect(proposal.proposal_contributes_count).to eq 1
        end
      end
    end
  end
end
