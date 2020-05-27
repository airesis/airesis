class FixWorkers
  def perform(*_args)
    AlertJob.all.find_each do |alert_job|
      alert_job.destroy if alert_job.sidekiq_job.blank?
    end
    EmailJob.all.find_each do |email_job|
      email_job.destroy if email_job.sidekiq_job.blank?
    end
  end
end
