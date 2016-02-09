require 'spec_helper'
require 'requests_helper'

describe 'the management of participation roles in a group', type: :feature, js: true do
  before :each do
    load_database
    @user = create(:user)
    @ability = Ability.new(@user)
    @group = create(:group, current_user_id: @user.id)
  end

  after :each do
    logout(:user)
  end

  it "can't manage roles if not logged in but asks to log in" do
    visit group_participation_roles_path(@group)
    expect_sign_in_page
  end

  it "can't Create roles if not logged in but asks to log in" do
    visit new_group_participation_role_path(@group)
    expect_sign_in_page
  end

  context 'other groups' do
    before(:each) do
      @user2 = create(:user)
      login_as @user2, scope: :user
    end
    it "can't manage participation roles" do
      visit group_participation_roles_path(@group)
      expect(page).to have_content(I18n.t('error.error_302.title'))
    end

    it "can't create participation roles" do
      visit new_group_participation_role_path(@group)
      expect(page).to have_content(I18n.t('error.error_302.title'))
    end
  end

  context 'participant' do
    before(:each) do
      @user2 = create(:user)
      create_participation(@user2, @group)
      login_as @user2, scope: :user
    end
    it "can't manage participation roles" do
      visit group_participation_roles_path(@group)
      expect(page).to have_content(I18n.t('error.error_302.title'))
    end

    it "can't create participation roles" do
      visit new_group_participation_role_path(@group)
      expect(page).to have_content(I18n.t('error.error_302.title'))
    end
  end

  context 'admin of group' do
    before(:each) do
      login_as @user, scope: :user
    end
    it 'view participation roles page' do
      visit group_participation_roles_path(@group)
      page_should_be_ok

      expect(page).to have_content I18n.t('pages.groups.edit_permissions.title')

      within('#main-copy') do
        @group.participation_roles.each_with_index do |participation_role, i|
          click_link participation_role.name if i > 0
          sleep 0.5
          within("#role_#{participation_role.id}") do
            GroupAction.all.each do |group_action|
              if DEFAULT_GROUP_ACTIONS.include? group_action.id
                expect(find(:css, "[data-action_id='#{group_action.id}']")).to be_checked
              else
                expect(find(:css, "[data-action_id='#{group_action.id}']")).to_not be_checked
              end
            end
          end
        end
      end
    end

    it 'creates participation roles' do
      visit new_group_participation_role_path(@group)

      role_name = Faker::Name.title
      within('#main-copy') do
        fill_in I18n.t('activerecord.attributes.participation_role.name'), with: role_name
        fill_in I18n.t('activerecord.attributes.participation_role.description'), with: Faker::Lorem.sentence
        click_button I18n.t('buttons.create')
      end

      expect(page).to have_content role_name
    end

    it 'manages participation role' do
      visit group_participation_roles_path(@group)
      within("#role_#{@group.participation_roles.first.id}") do
        DEFAULT_GROUP_ACTIONS.each do |group_action|
          find(:css, "[data-action_id='#{group_action}']").click
        end
      end
      wait_for_ajax
      expect(page).to have_content(I18n.t('info.participation_roles.permissions_updated'))
    end
  end
end
