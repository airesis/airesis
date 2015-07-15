# worker to create emails
class EmailsWorker
  include Sidekiq::Worker
  sidekiq_options queue: :low_priority

  def perform(attributes)
    ResqueMailer.notification(attributes).deliver_now
    email_job = EmailJob.find_by(jid: jid)
    email_job.try(:destroy)
  end
end
