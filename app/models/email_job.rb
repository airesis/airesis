class EmailJob < ActiveRecord::Base
  belongs_to :alert
  validates :alert_id, presence: true
  validates :jid, presence: true, uniqueness: true

  #enum :status, [:scheduled, :running, :completed, :canceled]

  def canceled!
    update(status: 3)
  end

  def completed?
    status == 2
  end

  def completed!
    update(status: 2)
  end

  def accumulate
    nt = alert.notification_type
    delay = (nt.email_delay + nt.alert_delay).minutes
    Sidekiq::ScheduledSet.new.find_job(jid).reschedule(delay.from_now)
  end
end
