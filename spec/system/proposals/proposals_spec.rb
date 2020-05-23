require 'rails_helper'
require 'requests_helper'
require 'cancan/matchers'

RSpec.describe 'create a proposal in his group', :js do
  let(:user) { create(:user) }
  let(:group) { create(:group, current_user_id: user.id) }
  let(:proposal) { create(:group_proposal, quorum: group.quorums.active.first, current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)]) }

  before do
    load_database
    login_as user, scope: :user
  end

  after do
    logout(:user)
  end

  it 'can edit a proposal' do
    visit edit_group_proposal_path(group, proposal)
    sleep 2
    new_content = Faker::Lorem.paragraph
    fill_in_ckeditor 'proposal_sections_attributes_0_paragraphs_attributes_0_content_dirty', with: new_content
    within_left_menu do
      click_link I18n.t('buttons.save_and_exit')
    end
    wait_for_ajax
    sleep 3
    expect(page).to have_current_path group_proposal_path(group, proposal)
    expect(page).to have_content(new_content)
  end

  it 'creates the proposal in group' do
    visit new_group_proposal_path(group)

    proposal_name = Faker::Lorem.sentence
    within('#main-copy') do
      fill_in I18n.t('pages.proposals.new.title_synthetic'), with: proposal_name
      fill_tokeninput '#proposal_tags_list', with: %w[tag1 tag2 tag3]
      fill_in_ckeditor 'proposal_sections_attributes_0_paragraphs_attributes_0_content', with: Faker::Lorem.paragraph
      quorum = group.quorums.find_by(name: '15 giorni')
      page.execute_script(%|$('#proposal_quorum_id').val(#{quorum.id}).trigger('change');|)
      wait_for_ajax
      click_button I18n.t('pages.proposals.new.create_button')
    end
    page_should_be_ok
    begin
      wait_for_ajax
    rescue StandardError
      nil
    end
    @proposal = Proposal.last

    expect(@proposal.vote_defined).to be_truthy
    # the proposal title is certainly displayed somewhere
    expect(page).to have_content @proposal.title
    expect(page).to have_current_path(edit_group_proposal_path(group, @proposal))

    page.execute_script 'window.confirm = function () { return true }'
    page.execute_script 'ProposalsEdit.safe_exit = true;'
    within_left_menu do
      click_link I18n.t('buttons.cancel')
    end

    expect(page).to have_content @proposal.title
    within_left_menu do
      expect(page).to have_content(I18n.t('proposals.show.ready_for_vote'))
      expect(page).to have_content(I18n.t('proposals.show.keep_discuss'))
    end
  end

  it 'evaluation of a proposal by the author and other users' do
    def vote_and_check
      ready_for_vote = I18n.t('proposals.show.ready_for_vote')
      keep_discuss = I18n.t('proposals.show.keep_discuss')
      within_left_menu do
        expect(page).to have_content(ready_for_vote)
        expect(page).to have_content(keep_discuss)
        click_link ready_for_vote
      end

      expect(page).to have_content(I18n.t('info.proposal.rank_recorderd'))

      within_left_menu do
        expect(find_link(ready_for_vote)[:href]).to eq 'javascript:void(0)'
        expect(page).not_to have_link(keep_discuss)
      end
    end

    def second_vote_and_check
      pressed = I18n.t('proposals.show.ready_for_vote')
      other = I18n.t('proposals.show.keep_discuss')
      within_left_menu do
        expect(find_link(pressed)[:href]).to eq 'javascript:void(0)'
        expect(page).to have_content(other)
        click_link other # change ides
      end

      expect(page).to have_content(I18n.t('info.proposal.rank_recorderd'))

      within_left_menu do
        expect(find_link(other)[:href]).to eq 'javascript:void(0)'
        expect(page).not_to have_link(pressed)
      end
    end

    visit group_proposal_path(group, proposal)
    expect(page).to have_current_path group_proposal_path(group, proposal)

    vote_and_check
    logout(:user)
    how_many = 3
    other_users = []
    how_many.times do |i|
      user2 = create(:user)
      other_users << user2
      create_participation(user2, group)
      login_as user2, scope: :user
      visit group_proposal_path(group, proposal)

      vote_and_check

      proposal.reload
      expect(proposal.valutations).to eq((i + 1) + 1)
      expect(Ability.new(user2)).not_to be_able_to(:rank_up, proposal)
      logout(:user)
    end

    group.reload

    expect(group.participants.count).to eq(how_many + 1)

    proposal.current_user_id = user.id

    new_title = Faker::Lorem.sentence
    proposal.update(title: new_title)

    login_as user, scope: :user

    expect(Ability.new(user)).to be_able_to(:rankup, proposal)
    expect(Ability.new(user)).to be_able_to(:rankdown, proposal)

    visit group_proposal_path(group, proposal)

    second_vote_and_check

    proposal.reload

    expect(proposal.valutations).to eq(how_many + 1)
    expect(proposal.rank).to eq((how_many.to_f / (how_many + 1)) * 100)

    logout :user
    how_many.times do |i|
      login_as other_users[i], scope: :user
      visit group_proposal_path(group, proposal)
      second_vote_and_check
      proposal.reload
      expect(proposal.valutations).to eq(how_many + 1)
      expect(proposal.rank).to eq(((how_many - (1 + i)).to_f / (how_many + 1)) * 100)
      expect(Ability.new(other_users[i])).not_to be_able_to(:rank_down, proposal)
      logout :user
    end
  end

  def create_proposal(type)
    visit group_proposals_path(group)
    within('.menu-left') do
      click_link I18n.t('proposals.create_button')
    end
    find("div[data-id=#{type}]").click

    proposal_name = Faker::Lorem.sentence
    fill_in I18n.t('pages.proposals.new.title_synthetic'), with: proposal_name
    fill_tokeninput '#proposal_tags_list', with: %w[tag1 tag2 tag3]
    fill_in_ckeditor 'proposal_sections_attributes_0_paragraphs_attributes_0_content', with: Faker::Lorem.paragraph
    quorum = group.quorums.find_by(name: '15 giorni')
    page.execute_script(%|$('#proposal_quorum_id').val(#{quorum.id}).trigger('change');|)
    click_button I18n.t('pages.proposals.new.create_button')
    expect(page).to have_content('Edit the proposal')
    page_should_be_ok
    proposal2 = Proposal.order(created_at: :desc).first
    expect(page).to have_current_path(edit_group_proposal_path(group, proposal2))
  end

  it 'creates a SIMPLE proposal in group through dialog window' do
    create_proposal('SIMPLE')
  end

  it 'creates a RULE_BOOK proposal in group through dialog window' do
    create_proposal('RULE_BOOK')
  end
  it 'creates a PRESS proposal in group through dialog window' do
    create_proposal('PRESS')
  end
  it 'creates a EVENT proposal in group through dialog window' do
    create_proposal('EVENT')
  end

  it 'creates a ESTIMATE proposal in group through dialog window' do
    create_proposal('ESTIMATE')
  end

  it 'creates a AGENDA proposal in group through dialog window' do
    create_proposal('AGENDA')
  end

  it 'creates a CANDIDATES proposal in group through dialog window' do
    create_proposal('CANDIDATES')
  end

  it 'creates a STANDARD proposal in group through dialog window' do
    create_proposal('STANDARD')
  end
end
