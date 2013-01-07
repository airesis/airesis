require 'rubygems'
require 'sitemap_generator'

SitemapGenerator::Sitemap.default_host = 'http://www.airesis.it'
SitemapGenerator::Sitemap.create do
  add '/', :changefreq => 'monthly', :priority => 0.9
  add '/proposals', :changefreq => 'weekly'
  
  Blog.find_each do |blog|
     add blog_path(blog), :changefreq => 'daily'#, :lastmod => blog.updated_at
    blog.posts.find_each do |post|
      add blog_blog_post_path(blog,post), :lastmod => post.updated_at
    end
  end
  
  Proposal.public.find_each do |proposal|
    add proposal_path(proposal), :lastmod => proposal.updated_at, :changefreq => 'daily'
  end
  
  Event.public.find_each do |event|
    add event_path(event), :lastmod => event.updated_at
  end

  Group.find_each do |group|
    add group_path(group), :changefreq => 'daily'#, :lastmod => group.updated_at
    #group.internal_proposals.find_each do |proposal|
    #  add group_proposal_path(group,proposal)
    #end
  end

  User.find_each do |user|
    add user_path(user), :changefreq => 'monthly', :lastmod => user.updated_at
  end
  
end
#SitemapGenerator::Sitemap.ping_search_engines # called for you when you use the rake task