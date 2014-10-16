require 'spec_helper'
require 'requests_helper'

describe BlogPostsController, :type => :controller do
  before(:each) do
    @user = create(:default_user)

  end
  describe "GET index" do
    before(:each) do
      @group = create(:default_group, current_user_id: @user.id)
      @blog = create(:blog, user: @user)
      @posts = []
      5.times do
        @posts << create(:blog_post, blog: @blog, user: @user)
      end
    end

    it "redirects to the group" do
      get :index, group_id: @group.id
      expect(response.code).to eq('302')
      expect(response).to redirect_to(@group)
    end

    it "redirects to the blog" do
      get :index, blog_id: @blog.id
      expect(response.code).to eq('302')
      expect(response).to redirect_to(@blog)
    end

    it "show public posts" do
      get :index
      expect(assigns[:blog_posts].to_a).to match_array(@posts)
    end

    it "do not show reserved posts" do
      blog_post = create(:blog_post, blog: @blog, user: @user, status: BlogPost::RESERVED)
      get :index
      expect(assigns[:blog_posts]).to_not include(blog_post)
    end

    it "do not show drafts posts" do
      blog_post = create(:blog_post, blog: @blog, user: @user, status: BlogPost::DRAFT)
      get :index
      expect(assigns[:blog_posts]).to_not include(blog_post)
    end
  end

  describe "GET new" do
    it "can't create blog post if has not a blog" do
      get :new
      expect(response.code).to eq('302')
    end
  end
end
