class FixWorkers
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { hourly }
  sidekiq_options queue: :low_priority

  def perform(*args)
    AlertJob.all.find_each do |alert_job|
      alert_job.destroy unless alert_job.sidekiq_job.present?
    end
    EmailJob.all.find_each do |email_job|
      email_job.destroy unless email_job.sidekiq_job.present?
    end
  end
end
