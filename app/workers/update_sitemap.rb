class UpdateSitemap
  include Sidekiq::Worker
  sidekiq_options queue: :low_priority

  def perform(*_args)
    Rake::Task['sitemap:refresh'].invoke
  end
end
