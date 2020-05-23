require 'rails_helper'
require 'requests_helper'
require 'cancan/matchers'

RSpec.describe 'check if quorums are working correctly', :js do
  let(:user) { create(:user) }
  let(:group) { create(:group, current_user_id: user.id) }
  let(:quorum) { create(:best_quorum, group_quorum: GroupQuorum.new(group: group)) } # min participants is 10% and good score is 50%. vote quorum 0, 50%+1
  let(:proposal) { create(:group_proposal, quorum: quorum, current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)], votation: { choise: 'new', start: 10.days.from_now, end: 14.days.from_now }) }

  before do
    load_database
  end

  it 'a proposal passes evaluation phase if the quorum is reached and votation date already defined' do
    # populate the group
    49.times do
      user = create(:user)
      create_participation(user, group)
    end
    # we now have 50 users in the group which can participate into a proposal

    expect(group.scoped_participants(:participate_proposals).count).to be(50)
    proposal # we create the proposal with the assigned quorum
    expect(proposal.quorum.valutations).to be(5 + 1) # calculated is ()0.1*50) + 1
    expect(proposal.quorum.good_score).to be 50 # copied
    expect(proposal.quorum.assigned).to be_truthy # copied

    group.participants.sample(10).each do |user|
      proposal.rankings.find_or_create_by(user_id: user.id) do |ranking|
        ranking.ranking_type_id = RankingType::POSITIVE
      end
    end

    proposal.reload

    expect(proposal.valutations).to be 10
    expect(proposal.rank).to be 100
    expect(proposal).to be_in_valutation

    proposal.check_phase(true)
    proposal.reload

    expect(proposal).to be_waiting

    proposal.vote_period.start_votation
    proposal.reload
    expect(proposal).to be_voting

    expect(group.scoped_participants(:vote_proposals).count).to be(50)
    expect(proposal).not_to be_is_schulze
    expect(proposal).not_to be_is_petition

    group.participants.sample(10).each do |user|
      create_simple_vote(user, proposal, VoteType::POSITIVE)
    end

    proposal.reload
    expect(proposal.vote.positive).to eq(10)
  end
end
