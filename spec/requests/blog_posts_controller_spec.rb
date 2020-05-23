require 'rails_helper'
require 'requests_helper'

RSpec.describe BlogPostsController, seeds: true do
  let!(:user) { create(:user) }

  describe 'GET index' do
    let(:group) { create(:group, current_user_id: user.id) }
    let(:blog) { create(:blog, user: user) }
    let!(:posts) { create_list(:blog_post, 5, blog: blog, user: user) }

    it 'redirects to the group' do
      get blog_posts_path, params: { group_id: group.id }
      expect(response.code).to eq('302')
      expect(response).to redirect_to(group)
    end

    it 'redirects to the blog' do
      get blog_posts_path, params: { blog_id: blog.id }
      expect(response.code).to eq('302')
      expect(response).to redirect_to(blog)
    end

    it 'show public posts' do
      get blog_posts_path
      expect(response.body).to include(*posts.map { |post| CGI.escapeHTML(post.title) })
    end

    it 'do not show reserved posts' do
      blog_post = create(:blog_post, blog: blog, user: user, status: BlogPost::RESERVED)
      get blog_posts_path
      expect(response.body).not_to include(blog_post.title)
    end

    it 'do not show drafts posts' do
      blog_post = create(:blog_post, blog: blog, user: user, status: BlogPost::DRAFT)
      get blog_posts_path
      expect(response.body).not_to include(blog_post.title)
    end
  end

  describe 'GET new' do
    it "can't create blog post if has not a blog" do
      get new_blog_post_path
      expect(response.code).to eq('302')
    end
  end
end
