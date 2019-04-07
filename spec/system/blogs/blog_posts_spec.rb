require 'rails_helper'
require 'requests_helper'

describe 'the blog posts process', :js, seeds: true do
  let!(:user) { create(:user) }
  let!(:blog) { create(:blog, user: user) }

  before do
    login_as user, scope: :user
  end

  after do
    logout(:user)
  end

  it 'can insert a blog_post in his blog and edit it' do
    visit blog_path(blog)
    expect(page).to have_content(I18n.t('pages.blog_posts.new_button'))
    within_left_menu do
      click_link I18n.t('pages.blog_posts.new_button')
    end
    expect(page).to have_content(I18n.t('pages.blog_posts.new_button'))
    blog_post_name = Faker::Company.name
    # fill form fields

    within('#main-copy') do
      fill_in I18n.t('activerecord.attributes.blog_post.title'), with: blog_post_name
      fill_in_ckeditor 'blog_post_body', with: Faker::Lorem.paragraph
      click_button I18n.t('buttons.save')
    end

    # the group name is certainly displayed somewhere
    expect(page).to have_content blog_post_name

    within('#blogPostContainer') do
      click_link blog_post_name
    end
    within_left_menu do
      click_link I18n.t('pages.blog_posts.show.edit_button')
    end

    # fill form fields
    blog_post_title = Faker::Company.name
    within('#main-copy') do
      fill_in I18n.t('activerecord.attributes.blog_post.title'), with: blog_post_title
      click_button I18n.t('buttons.save')
    end
    # success message!
    expect(page).to have_content(I18n.t('info.blog_post_updated'))
    # the new blog name is certainly displayed somewhere
    expect(page).to have_content blog_post_title
  end

  it 'can insert a blog_post in his group and edit it' do
    @ability = Ability.new(user)
    group = create(:group, current_user_id: user.id)
    visit group_path(group)

    expect(page).to have_content group.name
    within_left_menu do
      click_link I18n.t('pages.groups.show.post_button')
    end

    blog_post_name = Faker::Company.name
    # fill form fields
    within('#main-copy') do
      fill_in I18n.t('activerecord.attributes.blog_post.title'), with: blog_post_name
      fill_in_ckeditor 'blog_post_body', with: Faker::Lorem.paragraph
      click_button I18n.t('buttons.save')
    end

    # success message!
    expect(page).to have_content(I18n.t('info.blog_created'))
    # the group name is certainly displayed somewhere
    expect(page).to have_content group.name
    expect(page).to have_content blog_post_name

    within('#posts_container') do
      click_link blog_post_name
    end
    within_left_menu do
      click_link I18n.t('pages.blog_posts.show.edit_button')
    end
    # fill form fields
    blog_post_title = Faker::Company.name
    within('#main-copy') do
      fill_in I18n.t('activerecord.attributes.blog_post.title'), with: blog_post_title
      click_button I18n.t('buttons.save')
    end
    # success message!
    expect(page).to have_content(I18n.t('info.blog_post_updated'))
    # the new blog name is certainly displayed somewhere
    expect(page).to have_content blog_post_title
  end

  it 'can delete his blog posts' do
    blog_post = create(:blog_post, blog: blog, user: user)
    visit blog_blog_post_path(blog, blog_post)
    within_left_menu do
      click_link I18n.t('buttons.delete')
      page.driver.browser.switch_to.alert.accept
    end
    expect(page).to have_current_path(blog_path(blog))
    expect(page).to have_content(I18n.t('info.blog_post_deleted'))
  end

  it 'can delete published posts' do
    group = create(:group, current_user_id: user.id)
    blog_post = create(:blog_post, blog: blog, user: user)
    blog_post.groups << group
    blog_post.save

    visit group_blog_post_path(group, blog_post)
    within_left_menu do
      click_link I18n.t('buttons.delete')
      page.driver.browser.switch_to.alert.accept
    end
    expect(page).to have_current_path(group_path(group))
    expect(page).to have_content(I18n.t('info.blog_post_deleted'))
  end
end
