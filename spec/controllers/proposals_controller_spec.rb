require 'spec_helper'
require 'requests_helper'

describe ProposalsController, type: :controller, search: :true do

  let(:user) { create(:user) }
  let(:proposal1) { create(:public_proposal, title: 'bella giornata', current_user_id: user.id) }

  describe 'GET index' do
    it 'counts correctly debate proposals' do
      create(:public_proposal, current_user_id: user.id)
      get :index
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
      Proposal.reindex
      get :index
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

      Proposal.reindex

      get :index
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

      Proposal.reindex

      get :index
      expect(assigns(:in_valutation_count)).to be(1)
      expect(assigns(:in_votation_count)).to be(2)
      expect(assigns(:accepted_count)).to be(0)
      expect(assigns(:revision_count)).to be(2)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET tab_list' do
    before(:each) do
      proposal1
    end

    it 'retrieves public proposals in debate in debate tab' do
      get :tab_list, state: ProposalState::TAB_DEBATE
      expect(assigns(:proposals)).to eq([proposal1])
    end

    it 'retrieves public proposals waiting for date in votation tab' do
      proposal1.update({proposal_state_id: ProposalState::WAIT_DATE})
      Proposal.reindex
      get :tab_list, state: ProposalState::TAB_VOTATION
      expect(assigns(:proposals)).to eq([proposal1])
    end

    it 'retrieves public proposals waiting in votation tab' do
      proposal1.update({proposal_state_id: ProposalState::WAIT})
      Proposal.reindex
      get :tab_list, state: ProposalState::TAB_VOTATION
      expect(assigns(:proposals)).to eq([proposal1])
    end

    it 'retrieves public proposals in votation, in votation tab' do
      proposal1.update({proposal_state_id: ProposalState::VOTING})
      Proposal.reindex
      get :tab_list, state: ProposalState::TAB_VOTATION
      expect(assigns(:proposals)).to eq([proposal1])
    end

    it 'retrieves public proposals accepted, in voted tab' do
      proposal1.update({proposal_state_id: ProposalState::ACCEPTED})
      Proposal.reindex
      get :tab_list, state: ProposalState::TAB_VOTED
      expect(assigns(:proposals)).to eq([proposal1])
    end

    it 'retrieves public proposals rejected, in voted tab' do
      proposal1.update({proposal_state_id: ProposalState::REJECTED})
      Proposal.reindex
      get :tab_list, state: ProposalState::TAB_VOTED
      expect(assigns(:proposals)).to eq([proposal1])
    end

    it 'retrieves public proposals abandoned in abandoned tab' do
      proposal1.update({proposal_state_id: ProposalState::ABANDONED})
      Proposal.reindex
      get :tab_list, state: ProposalState::TAB_REVISION
      expect(assigns(:proposals)).to eq([proposal1])
    end

    it "can't retrieve private proposals not visible outside" do
      group = create(:group, current_user_id: user.id)
      proposal3 = create(:group_proposal, title: 'questo gruppo è un INFERNO! riorganizziamolo!!!!', current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)], visible_outside: false)
      get :tab_list, state: ProposalState::TAB_DEBATE
      expect(assigns(:proposals)).to eq([proposal1])
    end

    it 'can retrieve private proposals that are visible outside' do
      group = create(:group, current_user_id: user.id)
      proposal3 = create(:group_proposal, title: 'questo gruppo è un INFERNO! riorganizziamolo!!!!', current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)], visible_outside: true)

      get :tab_list, state: ProposalState::TAB_DEBATE
      expect(assigns(:proposals)).to match_array([proposal3, proposal1])
    end

    it "can't retrieve public proposals if specify a group, and can't see group's proposals if not signed in" do
      group = create(:group, current_user_id: user.id)
      proposal3 = create(:group_proposal, title: 'questo gruppo è un INFERNO! riorganizziamolo!!!!', current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)], visible_outside: false)

      get :tab_list, state: ProposalState::TAB_DEBATE, group_id: group.id
      expect(assigns(:proposals)).to eq([])
    end

    it "can't retrieve public proposals if specify a group, and can see group's proposals if signed in and is group admin" do
      group = create(:group, current_user_id: user.id)
      proposal3 = create(:group_proposal, title: 'questo gruppo è un INFERNO! riorganizziamolo!!!!', current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)], visible_outside: false)
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in user

      #repeat same request
      get :tab_list, state: ProposalState::TAB_DEBATE, group_id: group.id
      expect(assigns(:proposals)).to eq([proposal3])
    end
  end

  describe 'GET similar' do

    before(:each) do
      proposal1
    end

    it 'does not retrieve any results if no tag matches' do
      xhr :get, :similar, tags: 'a,b,c', format: :js
      expect(assigns(:proposals)).to eq([])
    end

    it 'retrieve correct result matching title but not tags' do
      xhr :get, :similar, tags: 'a,b,c', title: 'bella giornata', format: :js
      expect(assigns(:proposals)).to eq([proposal1])
    end

    it 'retrieve correct result matching title' do
      xhr :get, :similar, title: 'bella giornata', format: :js
      expect(assigns(:proposals)).to eq([proposal1])
    end

    it 'retrieve both proposals with correct tag' do
      proposal2 = create(:public_proposal, title: 'una giornata da inferno', current_user_id: user.id)
      xhr :get, :similar, tags: 'tag1', format: :js
      expect(assigns(:proposals)).to match_array([proposal1, proposal2])
    end

    it 'retrieve both proposals matching title with tag' do
      proposal2 = create(:public_proposal, title: 'una giornata da inferno', current_user_id: user.id)
      xhr :get, :similar, tags: 'giornata', format: :js
      expect(assigns(:proposals)).to eq([proposal1, proposal2])
    end

    it 'retrieve only one if only one matches' do
      proposal2 = create(:public_proposal, title: 'una giornata da inferno', current_user_id: user.id)
      xhr :get, :similar, tags: 'inferno', format: :js
      expect(assigns(:proposals)).to eq([proposal2])
    end

    it 'retrieve both proposals matching title' do
      proposal2 = create(:public_proposal, title: 'una giornata da inferno', current_user_id: user.id)
      xhr :get, :similar, title: 'giornata', format: :js
      expect(assigns(:proposals)).to eq([proposal1, proposal2])
    end

    it 'find first the most relevant' do
      proposal2 = create(:public_proposal, title: 'una giornata da inferno', current_user_id: user.id)
      xhr :get, :similar, title: 'inferno', tags: 'tag1', format: :js
      expect(assigns(:proposals)).to eq([proposal2, proposal1])
    end

    it 'find first the most relevant mixing title and tags' do
      proposal2 = create(:public_proposal, title: 'una giornata da inferno', current_user_id: user.id)
      xhr :get, :similar, title: 'inferno', tags: 'giornata', format: :js
      expect(assigns(:proposals)).to eq([proposal2, proposal1])
    end

    it 'find both also with some other words' do
      proposal2 = create(:public_proposal, title: 'una giornata da inferno', current_user_id: user.id)
      xhr :get, :similar, title: 'inferno', tags: 'giornata, tag1, parole, a, caso', format: :js
      expect(assigns(:proposals)).to eq([proposal2, proposal1])
    end

    it "does not retrieve nothing with wrong title" do
      proposal2 = create(:public_proposal, title: 'una giornata da inferno', quorum: BestQuorum.public.first, current_user_id: @user.id)
      xhr :get, :similar, title: 'rappresentative', format: :js
      expect(assigns(:proposals)).to eq([])
    end

    it "can't retrieve private proposals not visible outside" do
      proposal2 = create(:public_proposal, title: 'una giornata da inferno', current_user_id: user.id)
      xhr :get, :similar, title: 'inferno', format: :js
      expect(assigns(:proposals)).to eq([proposal2])
    end

    it 'can retrieve private proposals that are visible outside' do
      proposal2 = create(:public_proposal, title: 'una giornata da inferno', current_user_id: user.id)
      group = create(:group, current_user_id: user.id)
      proposal3 = create(:group_proposal, title: 'questo gruppo è un INFERNO! riorganizziamolo!!!!', current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)], visible_outside: true)
      xhr :get, :similar, title: 'inferno', format: :js
      expect(assigns(:proposals)).to match_array([proposal3, proposal2])
    end

    it "can't retrieve public proposals if specify a group, and can't see group's proposals if not signed in" do
      proposal2 = create(:public_proposal, title: 'una giornata da inferno', current_user_id: user.id)
      group = create(:group, current_user_id: user.id)
      proposal3 = create(:group_proposal, title: 'questo gruppo è un INFERNO! riorganizziamolo!!!!', current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)], visible_outside: false)
      xhr :get, :similar, title: 'inferno', group_id: group.id, format: :js
      expect(assigns(:proposals)).to eq([])
    end

    it "can't retrieve public proposals if specify a group, and can see group's proposals if signed in and is group admin" do
      proposal2 = create(:public_proposal, title: 'una giornata da inferno', current_user_id: user.id)
      group = create(:group, current_user_id: user.id)
      proposal3 = create(:group_proposal, title: 'questo gruppo è un INFERNO! riorganizziamolo!!!!', current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)], visible_outside: false)
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in user

      #repeat same request
      xhr :get, :similar, title: 'inferno', group_id: group.id, format: :js
      expect(assigns(:proposals)).to eq([proposal3])
    end

    it "can retrieve public proposals and can see group's proposals if signed in and is group admin" do
      proposal2 = create(:public_proposal, title: 'una giornata da inferno', current_user_id: user.id)
      group = create(:group, current_user_id: user.id)
      proposal3 = create(:group_proposal, title: 'questo gruppo è un INFERNO! riorganizziamolo!!!!', current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)], visible_outside: false)

      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in user

      #repeat same request
      xhr :get, :similar, title: 'inferno', format: :js
      expect(assigns(:proposals)).to eq([proposal3, proposal2])
    end

    it "can retrieve public proposals and can see group's proposals if he has enough permissions" do
      proposal2 = create(:public_proposal, title: 'una giornata da inferno', current_user_id: user.id)
      group = create(:group, current_user_id: user.id)
      proposal3 = create(:group_proposal, title: 'questo gruppo è un INFERNO! riorganizziamolo!!!!', current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)], visible_outside: false)

      user2 = create(:user)
      create_participation(user2, group)
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in user2

      xhr :get, :similar, title: 'inferno', format: :js
      expect(assigns(:proposals)).to eq([proposal3, proposal2])
    end

    it "can retrieve public proposals and can see group area's proposals if he has enough permissions" do
      group = create(:group, current_user_id: user.id)
      proposal3 = create(:group_proposal, title: 'questa giornata è un INFERNO! riorganizziamolo!!!!', current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)], visible_outside: false)

      user2 = create(:user)
      create_participation(user2, group)
      activate_areas(group)

      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in user2

      xhr :get, :similar, title: 'giornata', format: :js
      expect(assigns(:proposals)).to eq([proposal3, proposal1])
    end
  end
end
