require 'rails_helper'
require 'requests_helper'

RSpec.describe 'categories', :js, seeds: true do
  let!(:user) { create(:user) }

  let!(:group) { create(:group, current_user_id: user.id) }

  let!(:category_1) { create(:frm_category, group: group) }
  let!(:forum_1) { create(:frm_forum, category: category_1, group: group) }

  let!(:category_2) { create(:frm_category, group: group) }
  let!(:forum_2) { create(:frm_forum, category: category_2, group: group) }

  it 'sees categorized public forums' do
    visit group_forums_path(group)
    within("#category_#{category_1.id}") do
      expect(page).to have_content(forum_1.title)
    end

    within("#category_#{category_2.id}") do
      expect(page).to have_content(forum_2.title)
    end
  end

  it "can view a category's forums" do
    visit group_forums_path(group)

    within("#category_#{category_1.id}") do
      click_link category_1.name
    end

    expect(page).to have_content(forum_1.title)
    expect(page).not_to have_content(forum_2.title)
    expect(page).not_to match(forum_2.title)
  end

  context 'admin of group' do
    it 'can create a category' do
      login_as user, scope: :user
      visit group_frm_admin_categories_path(group)
      click_link I18n.t('frm.admin.category.new_link')
      name = Faker::Company.name
      fill_in I18n.t('simple_form.labels.frm_category.name'), with: name
      click_button I18n.t('helpers.submit.frm_category.create')
      expect(page).to have_content(I18n.t('frm.admin.category.created'))
      expect(page).to have_content(name)
    end

    it 'can update a category' do
      login_as user, scope: :user
      visit group_frm_admin_categories_path(group)
      within page.first('table tbody tr') do
        click_link I18n.t('edit', scope: 'frm.admin.categories')
      end
      name = Faker::Company.name
      fill_in I18n.t('simple_form.labels.frm_category.name'), with: name
      click_button I18n.t('helpers.submit.frm_category.update')
      expect(page).to have_content(I18n.t('frm.admin.category.updated'))
      expect(page).to have_content(name)
    end
  end
end
