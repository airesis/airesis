class NewsletterSender
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(newsletter_id, user_ids)
    user_ids.each do |user_id|
      ResqueMailer.delay.publish(newsletter_id, user_id)
    end
  end
end
