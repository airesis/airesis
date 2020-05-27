class EmailJob < ApplicationRecord
  belongs_to :alert
  validates :alert_id, presence: true
  validates :jid, presence: true, uniqueness: true

  def canceled!
    update(status: 3)
  end

  def completed?
    status == 2
  end

  def scheduled?
    status == 0
  end

  def completed!
    update(status: 2)
  end

  def sidekiq_job
    @sidekiq_job ||= Sidekiq::ScheduledSet.new.find_job(jid)
  end

  delegate :reschedule, to: :sidekiq_job

  def accumulate
    nt = alert.notification_type
    delay = (nt.email_delay + nt.alert_delay).minutes
    if sidekiq_job.present?
      reschedule(delay.from_now)
    else
      Rails.logger.error('sidekiq process not found when trying to accumulate on an existing email process')
    end
  end
end
