# a single notification sent to a user
class Alert < ActiveRecord::Base
  belongs_to :user, class_name: 'User', foreign_key: :user_id
  belongs_to :notification, class_name: 'Notification', foreign_key: :notification_id
  belongs_to :trackable, polymorphic: true

  attr_accessor :jid

  default_scope lambda {
    select('alerts.*, notifications.properties || alerts.properties as nproperties').
      joins(:notification)
  }

  has_one :notification_type, through: :notification
  has_one :notification_category, through: :notification_type
  has_one :email_job
  before_create :set_counter
  before_create :continue?

  after_commit :send_email, on: :create
  after_commit :private_pub, on: :create
  after_commit :complete_alert_job, on: :create

  def alert_job
    @alert_job ||= AlertJob.find_by(jid: jid)
  end

  def data
    ret = nproperties.with_indifferent_access
    ret[:count] = ret[:count].to_i
    ret.symbolize_keys
  end

  def data=(data)
    self.properties = data
  end

  def email_subject
    group = data[:group]
    subject = group ? "[#{group}] " : ''
    subject += I18n.t(notification.email_subject_interpolation, data)
  end

  def message
    I18n.t(notification.message_interpolation, data)
  end

  def check!
    update(checked: true, checked_at: Time.now)
  end

  def self.check_all
    update_all(checked: true, checked_at: Time.now)
  end

  def accumulate
    increase_count! # increase the count in the alert
    if email_job.present? && email_job.sidekiq_job.present? # an email is in queue?
      email_job.accumulate # requeue it on new daly
    else # alert is sent, email is sent, but alert is not read yet, just send a new email for the previous (accumulated) alert
      send_email(true)
    end
    private_pub
  end

  def increase_count!
    properties_will_change! # TODO: bugfix on Rails 4. to remove when patched
    count = properties['count'] ? properties['count'].to_i : 1
    properties['count'] = count + 1
    save!
  end

  def soft_delete
    update!(deleted: true, deleted_at: Time.now)
  end

  def self.soft_delete_all
    update_all(deleted: true, deleted_at: Time.now)
  end

  def trigger_user
    @trigger_user ||= User.find(nproperties['user_id'])
  end

  def image_url
    if nproperties['user_id'].present?
      if trackable.instance_of? Proposal
        trackable.user_avatar_url(trigger_user)
      else
        trigger_user.user_image_url
      end
    else
      ActionController::Base.helpers.asset_path("notification_categories/#{notification_category.short.downcase}.png")
    end
  end

  protected

  def continue?
    alert_job.nil? || !alert_job.canceled?
  end

  def set_counter
    properties_will_change!
    properties['count'] = alert_job ? alert_job.accumulated_count : 1
  end

  def send_email(add_alert_delay = false)
    return if checked?
    return if user.blocked?
    return if user.blocked_email_notifications.include? notification_type
    return unless user.email.present?
    delay = notification.notification_type.email_delay
    delay += notification.notification_type.alert_delay if add_alert_delay
    jid = EmailsWorker.perform_in(delay.minutes, id)
    EmailJob.create(alert: self, jid: jid)
  end

  def private_pub
    PrivatePub.publish_to("/notifications/#{user.id}", pull: 'hello')
  rescue
    Rails.logger.error 'Error while pushing to PrivatePub'
  end

  def complete_alert_job
    alert_job.destroy if alert_job
  end
end
