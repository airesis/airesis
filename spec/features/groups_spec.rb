require 'spec_helper'
require 'requests_helper'

describe "the creation of a group process", type: :feature, js: true do
  before :each do
    @user = create(:default_user)
    login_as @user, scope: :user
  end

  after :each do
    logout(:user)
  end

  it "creates a group correctly" do
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
  end
end