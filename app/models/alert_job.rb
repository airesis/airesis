class AlertJob < ApplicationRecord
  belongs_to :trackable, polymorphic: true
  belongs_to :notification_type
  belongs_to :user
  # TODO: why is this optional?
  belongs_to :alert, optional: true

  validates :trackable, presence: true
  validates :notification_type, presence: true
  validates :user, presence: true
  validates :jid, presence: true, uniqueness: true

  def canceled!
    update(status: 3)
  end

  def scheduled?
    status == 0
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

  def sidekiq_job
    @sidekiq_job ||= Sidekiq::ScheduledSet.new.find_job(jid)
  end

  delegate :reschedule, to: :sidekiq_job

  def accumulate(by = 1)
    increment!(:accumulated_count, by)
    if sidekiq_job.present?
      reschedule(notification_type.alert_delay.minutes.from_now)
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
    create!(trackable: trackable,
            notification_type: notification.notification_type,
            user: user,
            jid: jid)
  end
end
