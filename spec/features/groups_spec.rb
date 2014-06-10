require 'spec_helper'
require 'requests_helper'

describe "the creation of a group process", type: :feature, js: true do
  before :all do
    @user = create(:default_user)

  end

  before :each do
    login_as @user, scope: :user
  end

  after :each do
    logout(:user)
  end

  it "creates a group correctly and view main administration pages" do
    visit new_group_path
    expect(page).to have_title I18n.t('pages.groups.new.title')
    expect(page).to have_content(I18n.t('pages.groups.new.new_group'))
    #fill form fields
    group_name = Faker::Company.name
    within("#main-copy") do
      fill_in I18n.t('activerecord.attributes.group.name'), with: group_name
      fill_in_ckeditor 'group_description', with: Faker::Lorem.paragraph
      fill_tokeninput '#group_tags_list', with: ['tag1', 'tag2', 'tag3']
      fill_tokeninput '#group_interest_border_tkn', with: ['P-57']
      fill_in I18n.t('activerecord.attributes.group.default_role_name'), with: Faker::Name.title
      click_button I18n.t('pages.groups.new.create_button')
    end
    #success message!
    expect(page).to have_content(I18n.t('info.groups.group_created'))
    #the group name is certainly displayed somewhere
    expect(page).to have_content group_name
    #the user is a participant
    page.should have_selector('#participants_container', text: /#{@user.name}/i)

    @group = Group.order(created_at: :desc).first

    visit group_proposals_path(@group)
    page_should_be_ok

    visit group_events_path(@group)
    page_should_be_ok

    visit group_documents_path(@group)
    page_should_be_ok

    visit group_forums_path(@group)
    page_should_be_ok

    #group settings administration
    visit edit_group_path(@group)
    page_should_be_ok

    #roles administration
    visit group_participation_roles_path(@group)
    page_should_be_ok

    #users administration
    visit group_group_participations_path(@group)
    page_should_be_ok

    #quorums administration
    visit group_quorums_path(@group)
    page_should_be_ok

    #group areas administration
    visit group_group_areas_path(@group)
    page_should_be_ok

    #forum administration
    visit group_frm_admin_root_path(@group)
    page_should_be_ok

  end

end