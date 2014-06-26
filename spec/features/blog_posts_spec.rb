require 'spec_helper'
require 'requests_helper'

describe "the blog posts process", type: :feature, js: true do

  before :each do
    @user = create(:default_user)
    login_as @user, scope: :user
    @blog = create(:blog, user: @user)
  end

  after :each do
    logout(:user)
  end

  it "can insert a blog_post in his blog and edit it" do
    visit blog_path(@blog)
    expect(page).to have_content(I18n.t('pages.blog_posts.new_button'))
    click_link I18n.t('pages.blog_posts.new_button')

    blog_post_name = Faker::Company.name
    #fill form fields
    within("#main-copy") do
      fill_in I18n.t('activerecord.attributes.blog_post.title'), with: blog_post_name
      fill_in_ckeditor 'blog_post_body', with: Faker::Lorem.paragraph
      click_button I18n.t('buttons.save')
    end

    #the group name is certainly displayed somewhere
    expect(page).to have_content blog_post_name

    within('#blogPostContainer') do
      click_link blog_post_name
    end
    click_link I18n.t('pages.blog_posts.show.edit_button')

    #fill form fields
    blog_post_title = Faker::Company.name
    within("#main-copy") do
      fill_in I18n.t('activerecord.attributes.blog_post.title'), with: blog_post_title
      click_button I18n.t('buttons.save')
    end
    #success message!
    expect(page).to have_content(I18n.t('info.blog_post_updated'))
    #the new blog name is certainly displayed somewhere
    expect(page).to have_content blog_post_title


  end

  it "can insert a blog_post in his group and edit it" do
    @ability = Ability.new(@user)
    @group = create(:default_group, current_user_id: @user.id)
    visit group_path(@group)

    expect(page).to have_content @group.name

    click_link I18n.t('pages.groups.show.post_button')

    blog_post_name = Faker::Company.name
    #fill form fields
    within("#main-copy") do
      fill_in I18n.t('activerecord.attributes.blog_post.title'), with: blog_post_name
      fill_in_ckeditor 'blog_post_body', with: Faker::Lorem.paragraph
      click_button I18n.t('buttons.save')
    end

    #success message!
    expect(page).to have_content(I18n.t('info.blog_created'))
    #the group name is certainly displayed somewhere
    expect(page).to have_content @group.name
    expect(page).to have_content blog_post_name

    within('#posts_container') do
      click_link blog_post_name
    end
    click_link I18n.t('pages.blog_posts.show.edit_button')

    #fill form fields
    blog_post_title = Faker::Company.name
    within("#main-copy") do
      fill_in I18n.t('activerecord.attributes.blog_post.title'), with: blog_post_title
      click_button I18n.t('buttons.save')
    end
    #success message!
    expect(page).to have_content(I18n.t('info.blog_post_updated'))
    #the new blog name is certainly displayed somewhere
    expect(page).to have_content blog_post_title
  end
end