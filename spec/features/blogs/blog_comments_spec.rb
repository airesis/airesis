require 'spec_helper'
require 'requests_helper'
require "cancan/matchers"

describe 'the management of the blog posts', type: :feature, js: true do

  def fill_and_submit(page)
    expect(page).to have_content(I18n.t('pages.proposals.show.add_comment'))
    comment = Faker::Lorem.sentence
    within('#blogNewComment') do
      fill_in 'blog_comment_body', with: comment
      click_button I18n.t('pages.blog_comments.new.insert_comment')
    end
    comment
  end

  before :each do
    load_database
    @user = create(:user)
    @group = create(:group, current_user_id: @user.id)
    @blog = create(:blog, user: @user)
    @blog_post = create(:blog_post, blog: @blog, user: @user)
  end

  after :each do
    logout(:user)
  end

  it "can create blog comments if not logged in" do
    visit blog_blog_post_path(@blog,@blog_post)

    expect(page).to have_content(@blog_post.title)
    comment = fill_and_submit(page)
    expect(page).to have_selector('form#new_user')
    within('form#new_user') do
      fill_in 'user_login', :with => @user.email
      fill_in 'user_password', :with => 'topolino'
      click_button 'Login'
    end
    expect(page).to have_content(comment)
  end

  it "can create blog comments if logged in" do
    login_as @user, scope: :user
    visit blog_blog_post_path(@blog,@blog_post)

    expect(page).to have_content(@blog_post.title)
    comment = fill_and_submit(page)
    expect(page).to have_content(comment)
  end

  it "can create blog comments in reserved post if it's his post" do
    login_as @user, scope: :user
    @blog_post.update_attributes(status: BlogPost::RESERVED)
    visit blog_blog_post_path(@blog,@blog_post)

    expect(page).to have_content(@blog_post.title)
    comment = fill_and_submit(page)
    expect(page).to have_content(comment)
  end

  it "can create blog comments in draft post if it's his post" do
    login_as @user, scope: :user
    @blog_post.update_attributes(status: BlogPost::DRAFT)
    visit blog_blog_post_path(@blog,@blog_post)

    expect(page).to have_content(@blog_post.title)
    comment = fill_and_submit(page)
    expect(page).to have_content(comment)
  end

  it "can create blog comments in reserved post if it's in one of the groups in which participate" do
    @blog_post.groups << @group
    @blog_post.status = BlogPost::RESERVED
    @blog_post.save
    @user2 = create(:user)
    create_participation(@user2,@group)

    login_as @user2, scope: :user

    visit blog_blog_post_path(@blog,@blog_post)

    expect(page).to have_content(@blog_post.title)

    comment = fill_and_submit(page)
    expect(page).to have_content(comment)
    visit group_blog_post_path(@group,@blog_post)

    expect(page).to have_content(@blog_post.title)
    comment = fill_and_submit(page)
    expect(page).to have_content(comment)
  end
end
