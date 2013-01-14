class UpdateSitemap
  def self.perform(*args)
    Rake::Task["sitemap:refresh"].invoke
  end

end
