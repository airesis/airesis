class AlertJob < ActiveRecord::Base
  belongs_to :trackable, polymorphic: true
  belongs_to :notification_type
  belongs_to :user
  belongs_to :alert

  validates :trackable, presence: true
  validates :notification_type, presence: true
  validates :user, presence: true
  validates :jid, presence: true, uniqueness: true

  #enum :status, [:scheduled, :running, :completed, :canceled]

  def canceled!
    update(status: 3)
  end

  def canceled?
    status == 3
  end

  def completed?
    status == 2
  end

  def complete(alert)
    update(status: 2, alert: alert)
  end

  def accumulate(by = 1)
    increment!(:accumulated_count, by)
    sidekiq_job = Sidekiq::ScheduledSet.new.find_job(jid)
    if sidekiq_job
      sidekiq_job.reschedule(notification_type.alert_delay.minutes.from_now)
    else
      Rails.logger.error('sidekiq process not found when trying to accumulate on an existing alert process')
    end
  end

  def self.delay_for(notification)
    notification.notification_type.alert_delay.minutes
  end

  def self.factory(notification, user, trackable)
    jid = AlertsWorker.perform_in(delay_for(notification),
                                  user_id: user.id,
                                  notification_id: notification.id,
                                  checked: false,
                                  trackable_id: trackable.id,
                                  trackable_type: trackable.class.name)
    create(trackable: trackable,
           notification_type: notification.notification_type,
           user: user,
           jid: jid)
  end
end
