require 'spec_helper'
require 'requests_helper'

describe BlogPostsController, :type => :controller, search: :true do
  before(:each) do
    @user = create(:default_user)
    @blog = create(:blog, user: @user)
    posts = []
    5.times do
      posts << create(:blog_post, blog: @blog, user: @user)
    end
  end
  describe "GET index" do
    it "does not exists" do
      get blog_blog_posts_path(@blog)
      expect(response).to render_template(:index)
      expect(assigns[:blog_posts]).to be(posts.reverse)
    end
  end
end