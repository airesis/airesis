class FixWorkers
  def perform(*_args)
    AlertJob.all.find_each do |alert_job|
      alert_job.destroy unless alert_job.sidekiq_job.present?
    end
    EmailJob.all.find_each do |email_job|
      email_job.destroy unless email_job.sidekiq_job.present?
    end
  end
end
