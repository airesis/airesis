class UpdateSitemap
  include Sidekiq::Worker
  sidekiq_options queue: :low_priority

  def perform(*args)
    Rake::Task["sitemap:refresh"].invoke
  end

end
