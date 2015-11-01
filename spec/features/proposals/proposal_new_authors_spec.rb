require 'spec_helper'
require 'requests_helper'
require 'cancan/matchers'

describe 'the management of authors works quite good', type: :feature, js: true do
  let(:user) { create(:user) }
  let(:group) { create(:group, current_user_id: user.id) }
  let(:proposal) { create(:group_proposal, quorum: group.quorums.active.first, current_user_id: user.id, group_proposals: [GroupProposal.new(group: group)]) }

  before :each do
    load_database
  end

  after :each do
    logout(:user)
  end

  it 'request, accept and new author added' do
    user2 = create(:user)
    create_participation(user2, group)

    login_as user2, scope: :user

    visit group_proposal_path(group, proposal)

    page.execute_script 'window.confirm = function () { return true }'
    within_left_menu do
      click_link I18n.t('pages.proposals.show.offer_as_editor_button')
    end
    expect(page).to have_content I18n.t('info.proposal.offered_editor')
    expect(page).to_not have_content(I18n.t('pages.proposals.show.offer_as_editor_button'))
    expect(page).to have_content(I18n.t('pages.proposals.show.offered_as_editor_message'))

    logout :user

    login_as user, scope: :user

    visit group_proposal_path(group, proposal)

    within_left_menu do
      click_link I18n.t('pages.proposals.show.available_editors_button', count: 1)
    end
    expect(page).to have_content I18n.t('pages.proposals.show.editors_list_title')
    within('#available_authors_list_container') do
      expect(page).to have_content I18n.t('pages.proposals.show.editors_list_title')
      find('input[type=checkbox]').set(true)
      click_button I18n.t('buttons.save')
    end
    expect(page).to have_content I18n.t('info.proposal.authors_added')
    expect(proposal.users.count).to eq 2
  end
end
