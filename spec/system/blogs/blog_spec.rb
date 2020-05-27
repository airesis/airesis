require 'rails_helper'
require 'requests_helper'

RSpec.describe 'the blogs process', :js do
  before do
    @user = create(:user)
    login_as @user, scope: :user

    visit new_blog_path
    expect(page).to have_content I18n.t('pages.blogs.new.title')

    # fill form fields
    blog_name = Faker::Company.name
    within('#main-copy') do
      fill_in I18n.t('activerecord.attributes.blog.title'), with: blog_name
      click_button I18n.t('pages.blogs.new.create_button')
    end
    # success message!
    expect(page).to have_content(I18n.t('info.blog.blog_created'))
    # the blog name is certainly displayed somewhere
    expect(page).to have_content blog_name
  end

  after { logout(:user) }

  # TODO: do not test in system test but request
  it "creates his blog correctly and can't create it anymore", :ignore_javascript_errors do
    visit new_blog_path
    expect(page).to have_content(I18n.t('error.error_302.title'))
  end

  it 'can manage his blog' do
    @blog = Blog.order(created_at: :desc).first
    visit blog_path(@blog)
    expect(page).to have_content(I18n.t('pages.blog_posts.new_button'))
    expect(page).to have_content(I18n.t('pages.blog_posts.drafts_button'))
    expect(page).not_to have_content(I18n.t('pages.blog_posts.published_button'))
    expect(page).to have_content(I18n.t('pages.blogs.show.edit_button'))
    within_left_menu do
      click_link I18n.t('pages.blog_posts.drafts_button')
    end
    expect(page).to have_content(I18n.t('pages.blog_posts.new_button'))
    expect(page).not_to have_content(I18n.t('pages.blog_posts.drafts_button'))
    expect(page).to have_content(I18n.t('pages.blog_posts.published_button'))
    expect(page).to have_content(I18n.t('pages.blogs.show.edit_button'))
    within_left_menu do
      click_link I18n.t('pages.blogs.show.edit_button')
    end

    # fill form fields
    blog_name = Faker::Company.name
    within('#main-copy') do
      fill_in I18n.t('activerecord.attributes.blog.title'), with: blog_name

      click_button I18n.t('buttons.update')
    end
    # success message!
    expect(page).to have_content(I18n.t('info.blog.title_updated'))
    # the new blog name is certainly displayed somewhere
    expect(page).to have_content blog_name
    within_left_menu do
      click_link I18n.t('pages.blog_posts.new_button')
    end
  end
end
