require 'rails_helper'
require 'requests_helper'
require 'cancan/matchers'

RSpec.describe 'decide the votation date for a proposal', :js, seeds: true do
  let!(:user) { create(:user) }
  let!(:group) { create(:group, current_user_id: user.id) }

  let!(:proposal) { create(:group_proposal, quorum: group.quorums.active.first, current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)]) }
  let(:ability) { Ability.new(user) }

  before do
    login_as user, scope: :user
  end

  it 'can decide the vote date' do
    2.times do
      user = create(:user)
      create(:positive_ranking, proposal: proposal, user: user)
    end
    proposal.check_phase(true)
    proposal.reload
    expect(proposal).to be_waiting_date
    expect(ability).to be_able_to(:set_votation_date, proposal)
    visit group_proposal_path(group, proposal)
    expect(page).to have_content I18n.t('pages.proposals.show.create_votation_period')
    click_link I18n.t('pages.proposals.show.choose_new_votation_period_button')
    within('#create_event_dialog') do
      title = Faker::Lorem.sentence
      description = Faker::Lorem.paragraph
      fill_in I18n.t('activerecord.attributes.event.title'), with: title
      fill_in I18n.t('activerecord.attributes.event.description'), with: description

      click_link I18n.t('buttons.next')

      fill_in I18n.t('activerecord.attributes.event.starttime'), with: (I18n.l 1.day.from_now, format: :datepicker)
      page.execute_script("$('#event_starttime').fdatetimepicker('hide');")
      fill_in I18n.t('activerecord.attributes.event.endtime'), with: (I18n.l 3.days.from_now, format: :datepicker)
      page.execute_script("$('#event_endtime').fdatetimepicker('hide');")

      click_link I18n.t('pages.events.new.submit')
    end
    wait_for_ajax
    expect(page).to have_current_path(group_proposal_path(group, proposal))
    expect(page).to have_button I18n.t('pages.proposals.show.choose_votation_period_button')
    visit group_proposal_path(group, proposal)
    page.execute_script 'window.confirm = function () { return true }'
    click_button(I18n.t('pages.proposals.show.choose_votation_period_button'))
    expect(page).to have_content I18n.t('info.proposal.date_selected')
    proposal.reload
    expect(proposal).to be_waiting
  end
end
