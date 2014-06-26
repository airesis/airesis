require 'spec_helper'
require 'requests_helper'

describe 'categories', type: :feature do

  let!(:user) { create(:user) }

  let!(:group) { create(:group, current_user_id: user.id)}

  let!(:category_1) { FactoryGirl.create(:frm_category, group: group) }
  let!(:forum_1) { FactoryGirl.create(:frm_forum, category: category_1, group: group) }

  let!(:category_2) { FactoryGirl.create(:frm_category, group: group) }
  let!(:forum_2) { FactoryGirl.create(:frm_forum, :category => category_2, group: group) }

  it "sees categorised public forums" do

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
    expect(page).to_not have_content(forum_2.title)
    expect(page).to_not match(forum_2.title)
  end
end
