require 'rails_helper'
require 'requests_helper'

RSpec.describe 'the management of forum', :js do
  before do
    load_database
    @user = create(:user)
    @ability = Ability.new(@user)
    @group = create(:group, current_user_id: @user.id)
    login_as @user, scope: :user
  end

  after do
    logout(:user)
  end

  it 'can manage categories' do
    visit group_frm_admin_root_path(@group)
    page_should_be_ok
    click_link I18n.t('frm.admin.category.index')
    page_should_be_ok
    @group.categories.each do |category|
      expect(page).to have_content(category.name)
    end
    within('table tbody') do
      first(:link, I18n.t('buttons.edit')).click
    end
    new_name = Faker::Lorem.sentence
    fill_in I18n.t('simple_form.labels.frm_category.name'), with: new_name
    click_button I18n.t('buttons.update')
    page_should_be_ok
    expect(page).to have_content(new_name)
  end

  it 'can manage moderators' do
    visit group_frm_admin_root_path(@group)
    page_should_be_ok
    click_link I18n.t('frm.admin.mod.index')
    expect(page).to have_content(I18n.t('pages.forum_groups.index.create_first'))

    click_link I18n.t('frm.admin.mod.new')
    new_name = Faker::Lorem.sentence
    fill_in I18n.t('simple_form.labels.frm_category.name'), with: new_name
    click_button I18n.t('buttons.create')
    page_should_be_ok
    expect(page).to have_content(new_name)
  end
end
