require 'spec_helper'
require 'requests_helper'

describe 'groups#by_year_and_month', type: :feature, js: true, seeds: true do
  let!(:user) { create(:user) }
  let!(:group) { create(:group, current_user_id: user.id) }

  before :each do
    login_as user, scope: :user

  end

  after :each do
    logout :user
  end

  it 'can see posts from one year ago' do
    posts = Timecop.travel(1.year.ago) do
      create_list(:group_blog_post, 3, groups: [group])
    end
    visit posts_by_year_and_month_group_path(group, year: 1.year.ago.year, month: 1.year.ago.month)
    page_should_be_ok
    posts.each do |post|
      expect(page).to have_content(post.title)
    end
  end
end
