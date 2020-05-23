require 'rails_helper'

RSpec.describe SearchProposal, type: :model, search: true do
  let(:public_proposals) { create_list(:proposal, 3) }

  before do
    load_database
  end

  context 'no parameters' do
    before do
      public_proposals
      group = create(:group)
      user = create(:user)
      create_participation(user, group)
      group_proposals = create_list(:group_proposal, 2, groups: [group])
    end

    it 'returns all public proposals' do
      search_proposal = described_class.new
      search_proposal.proposal_state_tab = ProposalState::TAB_DEBATE
      expect(search_proposal.counters[ProposalState::TAB_DEBATE]).to eq 5
    end
  end

  describe 'text search' do
    it 'can search by text' do
      user = create(:user)
      group = create(:group, current_user_id: user.id)
      titles = ['hello everybody', 'how are you doing today', 'im a super proposal',
                'everyboday knows it', 'proposal good',
                'proposal bad', 'hello super', 'caccapupu', 'super super super', 'diamond knows']
      titles.each do |title|
        create(:group_proposal, title: title, current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)])
      end
      expect(Proposal.count).to eq 10

      %w[caccapupu
         today
         hello
         super].each do |search_term|
        search_proposal = described_class.new
        search_proposal.user_id = user.id
        search_proposal.group_id = group.id
        search_proposal.text = search_term
        titles.select { |d| d.exclude? search_term }.each do |title|
          expect(search_proposal.results.map(&:title)).not_to include(title)
        end
        expect(search_proposal.results.count).to(be >= 1, "No results for #{search_term}")
      end
    end
  end

  describe 'filter by status' do
    it 'filters the proposals correctly by their status', :aggregate_failures do
      debate_proposals = create_list(:proposal, 3) # debate
      in_vote_proposals = create_list(:in_vote_public_proposal, 2) # in vote
      abandoned_proposals = create_list(:abadoned_public_proposal, 1) # abandoned

      search_proposal = described_class.new
      search_proposal.proposal_state_tab = ProposalState::TAB_DEBATE
      expect(search_proposal.counters[ProposalState::TAB_DEBATE]).to eq 3
      expect(search_proposal.counters[ProposalState::TAB_VOTATION]).to eq 2
      expect(search_proposal.counters[ProposalState::TAB_REVISION]).to eq 1
      expect(search_proposal.results).to match_array debate_proposals
      search_proposal.proposal_state_tab = ProposalState::TAB_VOTATION
      expect(search_proposal.results).to match_array in_vote_proposals
      search_proposal.proposal_state_tab = ProposalState::TAB_REVISION
      expect(search_proposal.results).to match_array abandoned_proposals
    end
  end

  describe 'sorting' do
    context 'no sort parameter given' do
      it 'sorts results by best match' do
        hello_world = create(:proposal, title: 'hello world')
        my_best_hello = create(:proposal, title: 'my best hello')
        hello = create(:proposal, title: 'hello')

        search_proposal = described_class.new
        search_proposal.proposal_state_tab = ProposalState::TAB_DEBATE
        search_proposal.text = 'hello'
        expect(search_proposal.results.to_a).to eq [hello, my_best_hello, hello_world]
      end
    end

    context 'order by votes' do
      it 'sorts results by number of votes' do
        users = create_list(:user, 3)
        hello_world = create(:proposal, title: 'hello world')
        my_best_hello = create(:proposal, title: 'my best hello')
        hello = create(:proposal, title: 'hello')

        create(:positive_ranking, user: users[0], proposal: hello)
        create(:positive_ranking, user: users[0], proposal: hello_world)
        create(:positive_ranking, user: users[1], proposal: hello_world)
        create(:positive_ranking, user: users[0], proposal: my_best_hello)
        create(:positive_ranking, user: users[1], proposal: my_best_hello)
        create(:positive_ranking, user: users[2], proposal: my_best_hello)

        search_proposal = described_class.new
        search_proposal.proposal_state_tab = ProposalState::TAB_DEBATE
        search_proposal.text = 'hello'
        search_proposal.order_id = described_class::ORDER_BY_VOTES
        expect(search_proposal.results.to_a).to eq [my_best_hello, hello_world, hello]
      end
    end

    context 'order by end date of quorum' do
      it 'sorts results by the end date of the quorum' do
        users = create_list(:user, 3)
        hello_world = create(:proposal, title: 'hello world', quorum: create(:best_quorum, days_m: 2))
        my_best_hello = create(:proposal, title: 'my best hello', quorum: create(:best_quorum, days_m: 3))
        hello = create(:proposal, title: 'hello', quorum: create(:best_quorum, days_m: 1))

        search_proposal = described_class.new
        search_proposal.proposal_state_tab = ProposalState::TAB_DEBATE
        search_proposal.order_id = described_class::ORDER_BY_END
        search_proposal.order_dir = 'a'
        expect(search_proposal.results.to_a).to eq [hello, hello_world, my_best_hello]
      end
    end

    context 'order by end of votation' do
      it 'sorts results by end of the votation' do
        in_vote_proposal_1 = create(:in_vote_public_proposal, vote_duration: 4)
        in_vote_proposal_2 = create(:in_vote_public_proposal, vote_duration: 3)
        in_vote_proposal_3 = create(:in_vote_public_proposal, vote_duration: 5)

        search_proposal = described_class.new
        search_proposal.proposal_state_tab = ProposalState::TAB_VOTATION
        search_proposal.order_id = described_class::ORDER_BY_VOTATION_END
        search_proposal.order_dir = 'a'
        expect(search_proposal.results.to_a).to eq [in_vote_proposal_2, in_vote_proposal_1, in_vote_proposal_3]
      end
    end
  end

  describe 'group proposals' do
    it 'filters out public proposals not supported by the group and proposals from my other groups' do
      public_proposals = create_list(:proposal, 2)
      group = create(:group)
      another_group = create(:group)
      user = create(:user)
      create_participation(user, group)
      create_participation(user, another_group)

      group_proposals = create_list(:group_proposal, 2, groups: [group])
      another_group_proposals = create_list(:group_proposal, 2, groups: [another_group])

      search_proposal = described_class.new
      search_proposal.proposal_state_tab = ProposalState::TAB_DEBATE
      search_proposal.user = user
      search_proposal.group = group
      expect(search_proposal.results.to_a).to match_array group_proposals
      search_proposal.group = another_group
      expect(search_proposal.results.to_a).to match_array another_group_proposals
    end

    it "can't retrieve private proposals not visible outside" do
      user = create(:user)
      group = create(:group, current_user_id: user.id)
      proposal1 = create(:public_proposal, title: 'bella giornata', current_user_id: user.id)
      proposal3 = create(:group_proposal, title: 'questo gruppo è un INFERNO! riorganizziamolo!!!!', current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)], visible_outside: false)
      search_proposal = described_class.new
      search_proposal.proposal_state_tab = ProposalState::TAB_DEBATE
      expect(search_proposal.results.to_a).to match_array [proposal1]
    end

    it "can't retrieve public proposals if specifies a group, and can't see group's proposals if not signed in" do
      user = create(:user)
      group = create(:group, current_user_id: user.id)
      proposal1 = create(:public_proposal, title: 'bella giornata', current_user_id: user.id)
      proposal3 = create(:group_proposal,
                         title: 'questo gruppo è un INFERNO! riorganizziamolo!!!!',
                         current_user_id: user.id,
                         group_proposals: [GroupProposal.new(group: group)],
                         visible_outside: false)

      search_proposal = described_class.new
      search_proposal.proposal_state_tab = ProposalState::TAB_DEBATE
      search_proposal.group_id = group.id
      expect(search_proposal.results.to_a).to match_array []
    end

    it "can't retrieve public proposals if specify a group, and can see group's proposals if signed in and is group admin" do
      user = create(:user)
      group = create(:group, current_user_id: user.id)
      proposal1 = create(:public_proposal, title: 'bella giornata', current_user_id: user.id)
      proposal3 = create(:group_proposal,
                         title: 'questo gruppo è un INFERNO! riorganizziamolo!!!!',
                         current_user_id: user.id,
                         group_proposals: [GroupProposal.new(group: group)],
                         visible_outside: false)

      search_proposal = described_class.new
      search_proposal.user_id = user.id
      search_proposal.proposal_state_tab = ProposalState::TAB_DEBATE
      search_proposal.group_id = group.id
      expect(search_proposal.results.to_a).to match_array [proposal3]
    end

    context 'when the administrator checks a group proposals' do
      let(:user) { create(:admin) }

      it 'can see them' do
        group = create(:group, current_user_id: user.id)
        proposal = create(:group_proposal, groups: [group], visible_outside: false)
        search_proposal = described_class.new(user: user, group: group)
        expect(search_proposal.results.to_a).to match_array [proposal]
      end
    end
  end

  describe 'filters by territory' do
    it 'filters proposals by municipality' do
      bologna = create(:municipality, description: 'Bologna')
      modena = create(:municipality, description: 'Modena')
      bologna_proposals = create_list(:proposal, 2, interest_borders_tkn: InterestBorder.to_key(bologna))
      modena_proposals = create_list(:proposal, 2, interest_borders_tkn: InterestBorder.to_key(modena))

      search_proposal = described_class.new
      search_proposal.proposal_state_tab = ProposalState::TAB_DEBATE
      search_proposal.interest_border = InterestBorder.find_by!(territory_type: 'Municipality', territory_id: bologna.id)
      expect(search_proposal.results.to_a).to match_array bologna_proposals
    end
  end

  describe '#counters' do
    subject(:counters) { search.counters }

    let(:user) { create(:user) }
    let(:proposals) { create_list(:public_proposal, 7, current_user_id: user.id) }
    let(:group) { create(:group, current_user_id: user.id) }
    let(:group_proposals) do
      create_list(:group_proposal, 7, visible_outside: false, current_user_id: user.id, groups: [group])
    end

    let(:search) { described_class.new(user: user) }

    def mix_states(proposals)
      proposals[1].update(proposal_state_id: ProposalState::ABANDONED)
      proposals[2].update(proposal_state_id: ProposalState::WAIT_DATE)
      proposals[3].update(proposal_state_id: ProposalState::WAIT)
      proposals[4].update(proposal_state_id: ProposalState::VOTING)
      proposals[5].update(proposal_state_id: ProposalState::ACCEPTED)
      proposals[6].update(proposal_state_id: ProposalState::REJECTED)
    end

    before do
      mix_states(proposals)
      mix_states(group_proposals)
    end

    context 'when in open space' do
      it 'counts correctly proposals' do
        expect(counters[ProposalState::TAB_DEBATE]).to eq(1)
        expect(counters[ProposalState::TAB_VOTATION]).to eq(3)
        expect(counters[ProposalState::TAB_VOTED]).to eq(2)
        expect(counters[ProposalState::TAB_REVISION]).to eq(1)
      end
    end

    context 'when counting group proposals' do
      let(:search) { described_class.new(user: user, group: group) }

      it 'displays the numbers only of the specific group' do
        expect(counters[ProposalState::TAB_DEBATE]).to eq(1)
        expect(counters[ProposalState::TAB_VOTATION]).to eq(3)
        expect(counters[ProposalState::TAB_VOTED]).to eq(2)
        expect(counters[ProposalState::TAB_REVISION]).to eq(1)
      end
    end
  end

  describe '#similar' do
    let(:user) { create(:user) }
    let(:proposal1) { create(:public_proposal, title: 'bella giornata', current_user_id: user.id) }

    before { proposal1 }

    it 'does not retrieve any results if no tag matches' do
      search_proposal = described_class.new
      search_proposal.add_tags_and_title('a,b,c', nil)
      expect(search_proposal.similar).to eq([])
    end

    it 'retrieve correct result matching title but not tags' do
      search_proposal = described_class.new
      search_proposal.add_tags_and_title('a,b,c', 'bella giornata')
      expect(search_proposal.similar).to eq([proposal1])
    end

    it 'retrieve correct result matching title' do
      search_proposal = described_class.new
      search_proposal.add_tags_and_title(nil, 'bella giornata')
      expect(search_proposal.similar).to eq([proposal1])
    end

    it 'retrieve both proposals with correct tag' do
      proposal2 = create(:public_proposal, title: 'una giornata da inferno', current_user_id: user.id)
      search_proposal = described_class.new
      search_proposal.add_tags_and_title('tag1', nil)
      expect(search_proposal.similar).to eq([proposal1, proposal2])
    end

    it 'retrieve both proposals matching title with tag' do
      proposal2 = create(:public_proposal, title: 'una giornata da inferno', current_user_id: user.id)
      search_proposal = described_class.new
      search_proposal.add_tags_and_title('giornata', nil)
      expect(search_proposal.similar).to eq([proposal1, proposal2])
    end

    it 'retrieve only one if only one matches' do
      proposal2 = create(:public_proposal, title: 'una giornata da inferno', current_user_id: user.id)
      search_proposal = described_class.new
      search_proposal.add_tags_and_title('inferno', nil)
      expect(search_proposal.similar).to eq([proposal2])
    end

    it 'retrieve both proposals matching title' do
      proposal2 = create(:public_proposal, title: 'una giornata da inferno', current_user_id: user.id)
      search_proposal = described_class.new
      search_proposal.add_tags_and_title(nil, 'giornata')
      expect(search_proposal.similar).to eq([proposal1, proposal2])
    end

    it 'find first the most relevant' do
      proposal2 = create(:public_proposal, title: 'una giornata da inferno', current_user_id: user.id)
      search_proposal = described_class.new
      search_proposal.add_tags_and_title('tag1', 'inferno')
      expect(search_proposal.similar).to eq([proposal2, proposal1])
    end

    it 'find first the most relevant mixing title and tags' do
      proposal2 = create(:public_proposal, title: 'una giornata da inferno', current_user_id: user.id)
      search_proposal = described_class.new
      search_proposal.add_tags_and_title('giornata', 'inferno')
      expect(search_proposal.similar).to eq([proposal2, proposal1])
    end

    it 'find both also with some other words' do
      proposal2 = create(:public_proposal, title: 'una giornata da inferno', current_user_id: user.id)
      search_proposal = described_class.new
      search_proposal.add_tags_and_title('giornata, tag1, parole, a, caso', 'inferno')
      expect(search_proposal.similar).to eq([proposal2, proposal1])
    end

    it 'does not retrieve anything with a wrong title' do
      proposal2 = create(:public_proposal, title: 'una giornata da inferno', current_user_id: user.id)
      search_proposal = described_class.new
      search_proposal.add_tags_and_title(nil, 'rappresentative')
      expect(search_proposal.similar).to eq([])
    end

    it "can't retrieve private proposals not visible outside" do
      proposal2 = create(:public_proposal, title: 'una giornata da inferno', current_user_id: user.id)
      search_proposal = described_class.new
      search_proposal.add_tags_and_title(nil, 'inferno')
      expect(search_proposal.similar).to eq([proposal2])
    end

    it 'can retrieve private proposals that are visible outside' do
      proposal2 = create(:public_proposal, title: 'una giornata da inferno', current_user_id: user.id)
      group = create(:group, current_user_id: user.id)
      proposal3 = create(:group_proposal, title: 'questo gruppo è un INFERNO! riorganizziamolo!!!!', current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)], visible_outside: true)
      search_proposal = described_class.new
      search_proposal.add_tags_and_title('inferno', nil)
      expect(search_proposal.similar).to eq([proposal3, proposal2])
    end

    it "can't retrieve public proposals if specifies a group, and can't see group's proposals if not signed in" do
      hell_day = create(:public_proposal, title: 'una giornata da inferno', current_user_id: user.id)
      group = create(:group, current_user_id: user.id)
      hell_group = create(:group_proposal, title: 'questo gruppo è un INFERNO! riorganizziamolo!!!!',
                                           current_user_id: user.id,
                                           groups: [group], visible_outside: false)
      search_proposal = described_class.new
      search_proposal.add_tags_and_title('inferno', nil)
      search_proposal.group_id = group.id
      expect(search_proposal.similar).to eq([])
    end

    it "can't retrieve public proposals if specify a group, and can see group's proposals if signed in and is group admin" do
      proposal2 = create(:public_proposal, title: 'una giornata da inferno', current_user_id: user.id)
      group = create(:group, current_user_id: user.id)
      proposal3 = create(:group_proposal, title: 'questo gruppo è un INFERNO! riorganizziamolo!!!!', current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)], visible_outside: false)

      search_proposal = described_class.new
      search_proposal.add_tags_and_title('inferno', nil)
      search_proposal.user_id = user.id
      search_proposal.group_id = group.id
      expect(search_proposal.similar).to eq([proposal3])
    end

    it "can retrieve public proposals and can see group's proposals if signed in and is group admin" do
      proposal2 = create(:public_proposal, title: 'una giornata da inferno', current_user_id: user.id)
      group = create(:group, current_user_id: user.id)
      proposal3 = create(:group_proposal,
                         title: 'questo gruppo è un INFERNO! riorganizziamolo!!!!',
                         current_user_id: user.id,
                         groups: [group],
                         visible_outside: false)

      search_proposal = described_class.new
      search_proposal.add_tags_and_title('inferno', nil)
      search_proposal.user_id = user.id
      expect(search_proposal.similar).to eq([proposal3, proposal2])
    end

    it "can retrieve public proposals and can see group's proposals if he has enough permissions" do
      proposal2 = create(:public_proposal, title: 'una giornata da inferno', current_user_id: user.id)
      group = create(:group, current_user_id: user.id)
      proposal3 = create(:group_proposal, title: 'questo gruppo è un INFERNO! riorganizziamolo!!!!', current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)], visible_outside: false)

      user2 = create(:user)
      create_participation(user2, group)

      search_proposal = described_class.new
      search_proposal.add_tags_and_title('inferno', nil)
      search_proposal.user_id = user2.id
      expect(search_proposal.similar).to eq([proposal3, proposal2])
    end

    it "can retrieve public proposals and can see group area's proposals if he has enough permissions" do
      group = create(:group, current_user_id: user.id)
      proposal3 = create(:group_proposal, title: 'questa giornata è un INFERNO! riorganizziamolo!!!!', current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)], visible_outside: false)

      user2 = create(:user)
      create_participation(user2, group)
      activate_areas(group)

      search_proposal = described_class.new
      search_proposal.add_tags_and_title(nil, 'giornata')
      search_proposal.user_id = user2.id
      expect(search_proposal.similar).to eq([proposal3, proposal1])
    end
  end
end
