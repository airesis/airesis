require 'spec_helper'

describe Proposal, type: :model do
  let(:user) { create(:user) }
  let(:group) { create(:group, current_user_id: user.id) }
  let(:quorum) { create(:best_quorum, group_quorum: GroupQuorum.new(group: group)) } # min participants is 10% and good score is 50%. vote quorum 0, 50%+1
  let(:group_proposal) { create(:group_proposal, quorum: quorum, current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)], votation: { choise: 'new', start: 10.days.from_now, end: 14.days.from_now }) }
  let(:public_proposal) { create(:proposal, current_user_id: user.id) }

  context 'group proposal' do
    before(:each) do
      load_municipalities
      group_proposal
    end

    it 'can be destroyed' do
      expect(group_proposal.destroy).to be_truthy
    end
  end

  context 'public proposal' do
    before(:each) do
      load_database
      public_proposal
    end
    it 'can be destroyed when public' do
      expect(public_proposal.destroy).to be_truthy
    end
  end
end
