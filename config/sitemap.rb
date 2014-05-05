require 'rubygems'
require 'sitemap_generator'

SitemapGenerator::Sitemap.default_host = 'http://www.airesis.it'
SitemapGenerator::Sitemap.create do
  add proposals_path, changefreq: 'always', priority: 1
  add groups_path, changefreq: 'daily', priority: 0.9
  add edemocracy_path, changefreq: 'monthly', priority: 0.9
  add eparticipation_path, changefreq: 'monthly', priority: 0.9
  add municipality_path, changefreq: 'monthly', priority: 0.6
  add school_path, changefreq: 'monthly', priority: 0.6
  add story_path, changefreq: 'monthly', priority: 0.9
  add blogs_path, changefreq: 'daily', priority: 0.7
  add events_path, changefreq: 'daily', priority: 0.7
  add '?l=pt', changefreq: 'monthly', priority: 0.8
  add '?l=en', changefreq: 'monthly', priority: 0.8
  add '?l=eu', changefreq: 'monthly', priority: 0.8
end