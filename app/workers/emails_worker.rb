# worker to create emails
class EmailsWorker
  include Sidekiq::Worker
  sidekiq_options queue: :low_priority

  def perform(attributes)
    puts "attributes: #{attributes}"
    ResqueMailer.notification(attributes).deliver
    email_job = EmailJob.find_by(jid: jid)
    email_job.completed!
  end
end
