require 'spec_helper'
require 'requests_helper'

describe "create a proposal in his group", type: :feature, js: true do
  before :each do
    @user = create(:default_user)
    login_as @user, scope: :user
    @group = create(:default_group, current_user_id: @user.id)
  end

  after :each do
    logout(:user)
  end

  it "creates the proposal in group" do
    #visit group_proposals_path(@group)
    #click_link I18n.t('proposals.create_button')
    #find('div[data-id=SIMPLE]').click

    visit new_group_proposal_path(@group)

    proposal_name = Faker::Lorem.sentence
    within("#main-copy") do
      fill_in I18n.t('pages.proposals.new.title_synthetic'), with: proposal_name
      fill_tokeninput '#proposal_tags_list', with: ['tag1', 'tag2', 'tag3']
      fill_in_ckeditor 'proposal_sections_attributes_0_paragraphs_attributes_0_content', with: Faker::Lorem.paragraph
      select2("15 giorni", xpath: "//div[@id='s2id_proposal_quorum_id']")
      wait_for_ajax
      click_button I18n.t('pages.proposals.new.create_button')
    end
    page_should_be_ok

    @proposal = Proposal.order(:created_at).first
    #the proposal title is certainly displayed somewhere
    expect(page).to have_content @proposal.title
    expect(page.current_path).to eq(edit_group_proposal_path(@group,@proposal))

    page.execute_script 'window.confirm = function () { return true }'
    page.execute_script 'safe_exit = true;'
    within('.edit_proposal_panel') do
      click_link I18n.t('buttons.cancel')
    end
    #page.driver.browser.switch_to.alert.accept

    expect(page).to have_content @proposal.title
  end
end