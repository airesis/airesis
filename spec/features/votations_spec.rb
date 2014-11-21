require 'spec_helper'
require 'requests_helper'
require 'cancan/matchers'

describe "check if quorums are working correctly", type: :feature, js: true do

  let(:user) { create(:user) }
  let(:group) { create(:group, current_user_id: user.id) }
  let(:quorum) { create(:best_quorum, group_quorum: GroupQuorum.new(group: group)) } #min participants is 10% and good score is 50%. vote quorum 0, 50%+1
  let(:proposal) { create(:group_proposal, quorum: quorum, current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)], votation: {choise: 'new', start: 10.days.from_now, end: 14.days.from_now}) }


  def vote(classe='votegreen')
    visit group_proposal_path(group,proposal)
    expect(page).to have_content(I18n.t('pages.proposals.vote_panel.single_title'))
    expect(page).to have_content(proposal.secret_vote ? I18n.t('pages.proposals.vote_panel.secret_vote') : I18n.t('pages.proposals.vote_panel.clear_vote'))
    page.execute_script 'window.confirm = function () { return true }'
    find(".#{classe}").click
    expect(page).to have_content(I18n.t('votations.create.confirm'))
    proposal.reload
  end


  def vote_schulze(id=proposal.solutions[0].id)
    visit group_proposal_path(group,proposal)
    expect(page.html).to include(I18n.t('pages.proposals.vote_panel.schulze_title', max: 3))
    expect(page).to have_content(proposal.secret_vote ? I18n.t('pages.proposals.vote_panel.secret_vote') : I18n.t('pages.proposals.vote_panel.clear_vote'))
    if id.present?
      within (".solution_row[data-id=\"#{id}\"]") do
        #find('.slideNumber').find('option[value="3"]').click
        find('.slideNumber').select("3")
      end
    end

    page.execute_script 'window.confirm = function () { return true }'
    click_button I18n.t('pages.proposals.show.vote_button')
    expect(page).to have_content(I18n.t('votations.create.confirm'))
    expect(page.html).to_not include(I18n.t('pages.proposals.vote_panel.schulze_title', max: 3))
    expect(page).to have_content(I18n.t('pages.proposals.vote_panel.results_time', when: (I18n.l UserVote.last.created_at)))
    proposal.reload
  end

  it "they can vote in a simple way and the proposal get accepted" do
    #populate the group
    49.times do
      user2 = create(:user)
      create_participation(user2, group)
    end
    #we now have 50 users in the group which can participate into a proposal

    expect(group.scoped_participants(GroupAction::PROPOSAL_PARTICIPATION).count).to be(50)
    proposal #we create the proposal with the assigned quorum
    expect(proposal.quorum.valutations).to be (5+1) #calculated is ()0.1*50) + 1
    expect(proposal.quorum.good_score).to be 50 #copied
    expect(proposal.quorum.assigned).to be_truthy #copied

    group.participants.sample(10).each do |user|
      proposal.rankings.find_or_create_by(user_id: user.id) do |ranking|
        ranking.ranking_type_id = RankingType::POSITIVE
      end
    end

    proposal.reload

    expect(proposal.valutations).to be 10
    expect(proposal.rank).to be 100
    expect(proposal.in_valutation?).to be_truthy

    proposal.check_phase(true)
    proposal.reload

    expect(proposal.waiting?).to be_truthy

    proposal.vote_period.start_votation
    proposal.reload
    expect(proposal.voting?).to be_truthy

    expect(group.scoped_participants(GroupAction::PROPOSAL_VOTE).count).to be(50)

    expect(Ability.new(user)).to be_able_to(:vote, proposal)
    login_as user, scope: :user
    puts "login as #{user.email}"
    vote
    expect(proposal.vote.positive).to eq(1)

    logout :user

    users = group.participants.sample(4)
    expect(Ability.new(users[0])).to be_able_to(:vote, proposal)
    login_as users[0], scope: :user
    puts "login as #{users[0].email}"
    vote
    expect(proposal.vote.positive).to eq(2)

    logout :user

    login_as users[1], scope: :user
    puts "login as #{users[1].email}"
    vote('votered')
    expect(proposal.vote.positive).to eq(2)
    expect(proposal.vote.negative).to eq(1)

    logout :user

    login_as users[2], scope: :user
    expect(UserVote.find_by(user_id: users[2].id, proposal_id: proposal.id)).to be_nil
    vote('voteyellow')
    expect(proposal.vote.positive).to eq(2)
    expect(proposal.vote.negative).to eq(1)
    expect(proposal.vote.neutral).to eq(1)

    logout :user

    login_as users[3], scope: :user
    vote
    expect(proposal.vote.positive).to eq(3)
    expect(proposal.vote.negative).to eq(1)
    expect(proposal.vote.neutral).to eq(1)

    logout :user

    proposal.close_vote_phase
    proposal.reload
    expect(proposal.quorum.vote_valutations).to be(1)
    expect(proposal.accepted?).to be_truthy

  end


  it "they can vote in a simple way and the proposal get rejected" do
    #populate the group
    29.times do
      user2 = create(:user)
      create_participation(user2, group)
    end
    #we now have 50 users in the group which can participate into a proposal

    proposal #we create the proposal with the assigned quorum

    group.participants.sample(10).each do |user|
      proposal.rankings.find_or_create_by(user_id: user.id) do |ranking|
        ranking.ranking_type_id = RankingType::POSITIVE
      end
    end

    proposal.reload

    expect(proposal.valutations).to be 10
    expect(proposal.rank).to be 100
    expect(proposal.in_valutation?).to be_truthy

    proposal.check_phase(true)
    proposal.reload

    expect(proposal.waiting?).to be_truthy

    proposal.vote_period.start_votation
    proposal.reload
    expect(proposal.voting?).to be_truthy

    expect(group.scoped_participants(GroupAction::PROPOSAL_VOTE).count).to be(30)

    users = group.participants.sample(4)
    expect(Ability.new(users[0])).to be_able_to(:vote, proposal)
    login_as users[0], scope: :user
    vote('votered')
    expect(proposal.vote.positive).to eq(0)
    expect(proposal.vote.negative).to eq(1)

    logout :user

    login_as users[1], scope: :user
    vote('votered')
    expect(proposal.vote.positive).to eq(0)
    expect(proposal.vote.negative).to eq(2)

    logout :user

    login_as users[2], scope: :user
    vote('voteyellow')
    expect(proposal.vote.positive).to eq(0)
    expect(proposal.vote.negative).to eq(2)
    expect(proposal.vote.neutral).to eq(1)

    logout :user

    login_as users[3], scope: :user
    vote('votered')
    expect(proposal.vote.positive).to eq(0)
    expect(proposal.vote.negative).to eq(3)
    expect(proposal.vote.neutral).to eq(1)

    logout :user

    proposal.close_vote_phase
    proposal.reload
    expect(proposal.rejected?).to be_truthy
  end

  it "they can vote in a schulze way and the proposal get accepted" do
    #populate the group
    9.times do
      user2 = create(:user)
      create_participation(user2, group)
    end
    #we now have 10 users in the group which can participate into a proposal

    expect(group.scoped_participants(GroupAction::PROPOSAL_PARTICIPATION).count).to be(10)
    proposal #we create the proposal with the assigned quorum
    expect(proposal.quorum.valutations).to be (1+1) #calculated is ()0.1*10) + 1
    expect(proposal.quorum.good_score).to be 50 #copied
    expect(proposal.quorum.assigned).to be_truthy #copied

    group.participants.sample(3).each do |user|
      proposal.rankings.find_or_create_by(user_id: user.id) do |ranking|
        ranking.ranking_type_id = RankingType::POSITIVE
      end
    end

    proposal.reload
    add_solution(proposal)
    expect(proposal.solutions.count).to be 2
    expect(proposal.valutations).to be 3
    expect(proposal.rank).to be 100
    expect(proposal.in_valutation?).to be_truthy

    proposal.check_phase(true)
    proposal.reload

    expect(proposal.waiting?).to be_truthy

    proposal.vote_period.start_votation
    proposal.reload
    expect(proposal.voting?).to be_truthy

    expect(group.scoped_participants(GroupAction::PROPOSAL_VOTE).count).to be(10)

    group.participants.sample(4).each do |user1|
      expect(Ability.new(user1)).to be_able_to(:vote, proposal)
      login_as user1, scope: :user
      vote_schulze(proposal.solutions[1].id)
      logout :user
    end

    proposal.close_vote_phase
    proposal.reload
    expect(proposal.accepted?).to be_truthy
    expect(proposal.schulze_votes.sum(:count)).to be 4

    expect(proposal.solutions[0].schulze_score).to be 0
    expect(proposal.solutions[1].schulze_score).to be 1
  end


  it "they can vote in a schulze way and the proposal get rejected (no votes)" do
    #populate the group
    9.times do
      user2 = create(:user)
      create_participation(user2, group)
    end
    #we now have 10 users in the group which can participate into a proposal

    proposal #we create the proposal with the assigned quorum

    group.participants.sample(3).each do |user|
      proposal.rankings.find_or_create_by(user_id: user.id) do |ranking|
        ranking.ranking_type_id = RankingType::POSITIVE
      end
    end

    proposal.reload
    add_solution(proposal)

    proposal.check_phase(true)
    proposal.reload

    proposal.vote_period.start_votation
    proposal.reload

    proposal.close_vote_phase
    proposal.reload
    expect(proposal.rejected?).to be_truthy
    expect(proposal.schulze_votes.sum(:count)).to be 0

    expect(proposal.solutions[0].schulze_score).to be 0
    expect(proposal.solutions[1].schulze_score).to be 0
  end


  it "they can see vote results" do
    #populate the group
    9.times do
      user2 = create(:user)
      create_participation(user2, group)
    end
    #we now have 10 users in the group which can participate into a proposal

    proposal #we create the proposal with the assigned quorum

    group.participants.each do |user|
      proposal.rankings.find_or_create_by(user_id: user.id) do |ranking|
        ranking.ranking_type_id = RankingType::POSITIVE
      end
    end

    proposal.reload

    proposal.check_phase(true)
    proposal.reload

    proposal.vote_period.start_votation
    proposal.reload
    expect(proposal.voting?).to be_truthy

    group.participants.each do |user|
      vote = UserVote.new(user_id: user.id, proposal_id: proposal.id)
      vote.vote_type_id = VoteType::POSITIVE
      vote.save
      proposal.vote.positive += 1
      proposal.vote.save
    end

    proposal.vote_period.end_votation
    proposal.reload
    expect(proposal.voted?).to be_truthy
    expect(proposal.accepted?).to be_truthy

    user = group.participants.sample

    login_as user, scope: :user
    visit group_proposal_path(group,proposal)
    within('#menu-left') do
      click_link I18n.t('pages.proposals.show.votation_results')
    end

    expect(page).to have_content I18n.t('pages.proposals.results.total', count: 10)
    expect(proposal.vote.number).to eq(10)
    logout :user
  end
end
