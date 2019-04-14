require 'rails_helper'
require 'requests_helper'

RSpec.describe ProposalsController, search: true, seeds: true do
  let(:user) { create(:user) }
  let(:proposal1) { create(:public_proposal, title: 'bella giornata', current_user_id: user.id) }

  describe 'GET index' do
    it 'counts correctly debate proposals', :aggregate_failures do
      create(:public_proposal, current_user_id: user.id)
      get proposals_path
      expect(assigns(:in_valutation_count)).to be(1)
      expect(assigns(:in_votation_count)).to be(0)
      expect(assigns(:accepted_count)).to be(0)
      expect(assigns(:revision_count)).to be(0)
    end

    it 'counts correctly votation proposals' do
      proposals = create_list(:public_proposal, 6, current_user_id: user.id)
      proposals[3].update(proposal_state_id: ProposalState::WAIT_DATE)
      proposals[4].update(proposal_state_id: ProposalState::WAIT)
      proposals[5].update(proposal_state_id: ProposalState::VOTING)
      get proposals_path
      expect(assigns(:in_valutation_count)).to be(3)
      expect(assigns(:in_votation_count)).to be(3)
      expect(assigns(:accepted_count)).to be(0)
      expect(assigns(:revision_count)).to be(0)
    end

    it 'counts correctly voted proposals' do
      proposals = create_list(:public_proposal, 8, current_user_id: user.id)
      proposals[3].update(proposal_state_id: ProposalState::WAIT_DATE)
      proposals[4].update(proposal_state_id: ProposalState::WAIT)
      proposals[5].update(proposal_state_id: ProposalState::VOTING)
      proposals[6].update(proposal_state_id: ProposalState::ACCEPTED)
      proposals[7].update(proposal_state_id: ProposalState::REJECTED)

      get proposals_path
      expect(assigns(:in_valutation_count)).to be(3)
      expect(assigns(:in_votation_count)).to be(3)
      expect(assigns(:accepted_count)).to be(2)
      expect(assigns(:revision_count)).to be(0)
    end

    it 'counts correctly abandoned proposals' do
      proposals = create_list(:public_proposal, 5, current_user_id: user.id)
      proposals[3].update(proposal_state_id: ProposalState::WAIT_DATE)
      proposals[4].update(proposal_state_id: ProposalState::WAIT)
      proposals[2].update(proposal_state_id: ProposalState::ABANDONED)
      proposals[1].update(proposal_state_id: ProposalState::ABANDONED)

      get proposals_path
      expect(assigns(:in_valutation_count)).to be(1)
      expect(assigns(:in_votation_count)).to be(2)
      expect(assigns(:accepted_count)).to be(0)
      expect(assigns(:revision_count)).to be(2)
    end

    it 'renders the index template' do
      get proposals_path
      expect(response).to render_template(:index)
    end
  end

  describe 'GET tab_list' do
    before { proposal1 }

    it 'retrieves public proposals in debate in debate tab' do
      get tab_list_proposals_path, params: { state: ProposalState::TAB_DEBATE }
      expect(assigns(:proposals)).to eq([proposal1])
    end

    it 'retrieves public proposals waiting for date in votation tab' do
      proposal1.update(proposal_state_id: ProposalState::WAIT_DATE)
      get tab_list_proposals_path, params: { state: ProposalState::TAB_VOTATION }
      expect(assigns(:proposals)).to eq([proposal1])
    end

    it 'retrieves public proposals waiting in votation tab' do
      proposal1.update(proposal_state_id: ProposalState::WAIT)
      get tab_list_proposals_path, params: { state: ProposalState::TAB_VOTATION }
      expect(assigns(:proposals)).to eq([proposal1])
    end

    it 'retrieves public proposals in votation, in votation tab' do
      proposal1.update(proposal_state_id: ProposalState::VOTING)
      get tab_list_proposals_path, params: { state: ProposalState::TAB_VOTATION }
      expect(assigns(:proposals)).to eq([proposal1])
    end

    it 'retrieves public proposals accepted, in voted tab' do
      proposal1.update(proposal_state_id: ProposalState::ACCEPTED)
      get tab_list_proposals_path, params: { state: ProposalState::TAB_VOTED }
      expect(assigns(:proposals)).to eq([proposal1])
    end

    it 'retrieves public proposals rejected, in voted tab' do
      proposal1.update(proposal_state_id: ProposalState::REJECTED)
      get tab_list_proposals_path, params: { state: ProposalState::TAB_VOTED }
      expect(assigns(:proposals)).to eq([proposal1])
    end

    it 'retrieves public proposals abandoned in abandoned tab' do
      proposal1.update(proposal_state_id: ProposalState::ABANDONED)
      get tab_list_proposals_path, params: { state: ProposalState::TAB_REVISION }
      expect(assigns(:proposals)).to eq([proposal1])
    end

    it "can't retrieve private proposals not visible outside" do
      group = create(:group, current_user_id: user.id)
      proposal3 = create(:group_proposal, title: 'questo gruppo è un INFERNO! riorganizziamolo!!!!', current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)], visible_outside: false)
      get tab_list_proposals_path, params: { state: ProposalState::TAB_DEBATE }
      expect(assigns(:proposals)).to eq([proposal1])
    end

    it 'can retrieve private proposals that are visible outside' do
      group = create(:group, current_user_id: user.id)
      proposal3 = create(:group_proposal,
                         title: 'questo gruppo è un INFERNO! riorganizziamolo!!!!',
                         current_user_id: user.id,
                         group_proposals: [GroupProposal.new(group: group)],
                         visible_outside: true)
      get tab_list_proposals_path, params: { state: ProposalState::TAB_DEBATE }
      expect(assigns(:proposals)).to match_array([proposal3, proposal1])
    end

    it "can't retrieve public proposals if specifies a group, and can't see group's proposals if not signed in" do
      group = create(:group, current_user_id: user.id)
      proposal3 = create(:group_proposal,
                         title: 'questo gruppo è un INFERNO! riorganizziamolo!!!!',
                         current_user_id: user.id,
                         group_proposals: [GroupProposal.new(group: group)],
                         visible_outside: false)

      get tab_list_proposals_path, params: { state: ProposalState::TAB_DEBATE, group_id: group.id }
      expect(assigns(:proposals)).to eq([])
    end

    it "can't retrieve public proposals if specify a group, and can see group's proposals if signed in and is group admin" do
      group = create(:group, current_user_id: user.id)
      proposal3 = create(:group_proposal,
                         title: 'questo gruppo è un INFERNO! riorganizziamolo!!!!',
                         current_user_id: user.id,
                         group_proposals: [GroupProposal.new(group: group)],
                         visible_outside: false)
      sign_in user

      # repeat same request
      get tab_list_proposals_path, params: { state: ProposalState::TAB_DEBATE, group_id: group.id }
      expect(assigns(:proposals)).to eq([proposal3])
    end
  end

  describe 'GET similar' do
    before do
      proposal1
    end

    it 'does not retrieve any results if no tag matches' do
      get similar_proposals_path, params: { tags: 'a,b,c' }, xhr: true
      expect(assigns(:proposals)).to eq([])
    end

    it 'retrieve correct result matching title but not tags' do
      get similar_proposals_path, params: { tags: 'a,b,c', title: 'bella giornata' }, xhr: true
      expect(assigns(:proposals)).to eq([proposal1])
    end

    it 'retrieve correct result matching title' do
      get similar_proposals_path, params: { title: 'bella giornata' }, xhr: true
      expect(assigns(:proposals)).to eq([proposal1])
    end

    it 'retrieve both proposals with correct tag' do
      proposal2 = create(:public_proposal, title: 'una giornata da inferno', current_user_id: user.id)
      get similar_proposals_path, params: { tags: 'tag1' }, xhr: true
      expect(assigns(:proposals)).to match_array([proposal1, proposal2])
    end

    it 'retrieve both proposals matching title with tag' do
      proposal2 = create(:public_proposal, title: 'una giornata da inferno', current_user_id: user.id)
      get similar_proposals_path, params: { tags: 'giornata' }, xhr: true
      expect(assigns(:proposals)).to eq([proposal1, proposal2])
    end

    it 'retrieve only one if only one matches' do
      proposal2 = create(:public_proposal, title: 'una giornata da inferno', current_user_id: user.id)
      get similar_proposals_path, params: { tags: 'inferno' }, xhr: true
      expect(assigns(:proposals)).to eq([proposal2])
    end

    it 'retrieve both proposals matching title' do
      proposal2 = create(:public_proposal, title: 'una giornata da inferno', current_user_id: user.id)
      get similar_proposals_path, params: { title: 'giornata', format: :js }, xhr: true
      expect(assigns(:proposals)).to eq([proposal1, proposal2])
    end

    it 'find first the most relevant' do
      proposal2 = create(:public_proposal, title: 'una giornata da inferno', current_user_id: user.id)
      get similar_proposals_path, params: { title: 'inferno', tags: 'tag1', format: :js }, xhr: true
      expect(assigns(:proposals)).to eq([proposal2, proposal1])
    end

    it 'find first the most relevant mixing title and tags' do
      proposal2 = create(:public_proposal, title: 'una giornata da inferno', current_user_id: user.id)
      get similar_proposals_path, params: { title: 'inferno', tags: 'giornata', format: :js }, xhr: true
      expect(assigns(:proposals)).to eq([proposal2, proposal1])
    end

    it 'find both also with some other words' do
      proposal2 = create(:public_proposal, title: 'una giornata da inferno', current_user_id: user.id)
      get similar_proposals_path, params: { title: 'inferno', tags: 'giornata, tag1, parole, a, caso', format: :js }, xhr: true
      expect(assigns(:proposals)).to eq([proposal2, proposal1])
    end

    it 'does not retrieve anything with a wrong title' do
      proposal2 = create(:public_proposal, title: 'una giornata da inferno', current_user_id: user.id)
      get similar_proposals_path, params: { title: 'rappresentative', format: :js }, xhr: true
      expect(assigns(:proposals)).to eq([])
    end

    it "can't retrieve private proposals not visible outside" do
      proposal2 = create(:public_proposal, title: 'una giornata da inferno', current_user_id: user.id)
      get similar_proposals_path, params: { title: 'inferno', format: :js }, xhr: true
      expect(assigns(:proposals)).to eq([proposal2])
    end

    it 'can retrieve private proposals that are visible outside' do
      proposal2 = create(:public_proposal, title: 'una giornata da inferno', current_user_id: user.id)
      group = create(:group, current_user_id: user.id)
      proposal3 = create(:group_proposal, title: 'questo gruppo è un INFERNO! riorganizziamolo!!!!', current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)], visible_outside: true)
      get similar_proposals_path, params: { title: 'inferno', format: :js }, xhr: true
      expect(assigns(:proposals)).to match_array([proposal3, proposal2])
    end

    it "can't retrieve public proposals if specifies a group, and can't see group's proposals if not signed in" do
      hell_day = create(:public_proposal, title: 'una giornata da inferno', current_user_id: user.id)
      group = create(:group, current_user_id: user.id)
      hell_group = create(:group_proposal, title: 'questo gruppo è un INFERNO! riorganizziamolo!!!!',
                                           current_user_id: user.id,
                                           groups: [group], visible_outside: false)
      get similar_proposals_path, params: { title: 'inferno', group_id: group.id, format: :js }, xhr: true
      expect(assigns(:proposals)).to eq([])
    end

    it "can't retrieve public proposals if specify a group, and can see group's proposals if signed in and is group admin" do
      proposal2 = create(:public_proposal, title: 'una giornata da inferno', current_user_id: user.id)
      group = create(:group, current_user_id: user.id)
      proposal3 = create(:group_proposal, title: 'questo gruppo è un INFERNO! riorganizziamolo!!!!', current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)], visible_outside: false)
      sign_in user

      # repeat same request
      get similar_proposals_path, params: { title: 'inferno', group_id: group.id, format: :js }, xhr: true
      expect(assigns(:proposals)).to eq([proposal3])
    end

    it "can retrieve public proposals and can see group's proposals if signed in and is group admin" do
      proposal2 = create(:public_proposal, title: 'una giornata da inferno', current_user_id: user.id)
      group = create(:group, current_user_id: user.id)
      proposal3 = create(:group_proposal,
                         title: 'questo gruppo è un INFERNO! riorganizziamolo!!!!',
                         current_user_id: user.id,
                         groups: [group],
                         visible_outside: false)

      sign_in user

      get similar_proposals_path, params: { title: 'inferno', format: :js }, xhr: true
      expect(assigns(:proposals)).to eq([proposal3, proposal2])
    end

    it "can retrieve public proposals and can see group's proposals if he has enough permissions" do
      proposal2 = create(:public_proposal, title: 'una giornata da inferno', current_user_id: user.id)
      group = create(:group, current_user_id: user.id)
      proposal3 = create(:group_proposal, title: 'questo gruppo è un INFERNO! riorganizziamolo!!!!', current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)], visible_outside: false)

      user2 = create(:user)
      create_participation(user2, group)
      sign_in user2

      get similar_proposals_path, params: { title: 'inferno', format: :js }, xhr: true
      expect(assigns(:proposals)).to eq([proposal3, proposal2])
    end

    it "can retrieve public proposals and can see group area's proposals if he has enough permissions" do
      group = create(:group, current_user_id: user.id)
      proposal3 = create(:group_proposal, title: 'questa giornata è un INFERNO! riorganizziamolo!!!!', current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)], visible_outside: false)

      user2 = create(:user)
      create_participation(user2, group)
      activate_areas(group)

      sign_in user2

      get similar_proposals_path, params: { title: 'giornata', format: :js }, xhr: true
      expect(assigns(:proposals)).to eq([proposal3, proposal1])
    end
  end
end
