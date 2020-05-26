require 'rails_helper'
require 'requests_helper'

RSpec.describe 'the management of participation roles in a group', :js do
  before do
    load_database
    @user = create(:user)
    @ability = Ability.new(@user)
    @group = create(:group, current_user_id: @user.id)
  end

  after do
    logout(:user)
  end

  it "can't manage roles if not logged in but asks to log in" do
    visit group_participation_roles_path(@group)
    expect_sign_in_page
  end

  it "can't create roles if not logged in but asks to log in" do
    visit new_group_participation_role_path(@group)
    expect_sign_in_page
  end

  context 'other groups' do
    before do
      @user2 = create(:user)
      login_as @user2, scope: :user
    end

    # TODO: do not test in system test but request
    it "can't manage participation roles", :ignore_javascript_errors do
      visit group_participation_roles_path(@group)
      expect(page).to have_content(I18n.t('error.error_302.title'))
    end

    # TODO: do not test in system test but request
    it "can't create participation roles", :ignore_javascript_errors do
      visit new_group_participation_role_path(@group)
      expect(page).to have_content(I18n.t('error.error_302.title'))
    end
  end

  context 'participant' do
    before do
      @user2 = create(:user)
      create_participation(@user2, @group)
      login_as @user2, scope: :user
    end

    # TODO: do not test in system test but request
    it "can't manage participation roles", :ignore_javascript_errors do
      visit group_participation_roles_path(@group)
      expect(page).to have_content(I18n.t('error.error_302.title'))
    end

    # TODO: do not test in system test but request
    it "can't create participation roles", :ignore_javascript_errors do
      visit new_group_participation_role_path(@group)
      expect(page).to have_content(I18n.t('error.error_302.title'))
    end
  end

  context 'admin of group' do
    before do
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
            GroupAction::LIST.each do |group_action|
              if DEFAULT_GROUP_ACTIONS.include? group_action
                expect(find(:css, "#participation_role_#{group_action}")).to be_checked
              else
                expect(find(:css, "#participation_role_#{group_action}")).not_to be_checked
              end
            end
          end
        end
      end
    end

    it 'creates participation roles' do
      visit new_group_participation_role_path(@group)

      role_name = Faker::Name.prefix
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
          find(:css, "#participation_role_#{group_action}").click
        end
      end
      wait_for_ajax
      expect(page).to have_content(I18n.t('info.participation_roles.role_updated'))
    end
  end
end
