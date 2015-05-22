# a single notification sent to a user
class Alert < ActiveRecord::Base
  belongs_to :user, class_name: 'User', foreign_key: :user_id
  belongs_to :notification, class_name: 'Notification', foreign_key: :notification_id
  belongs_to :trackable, polymorphic: true

  attr_accessor :jid

  default_scope -> {
    select('alerts.*, notifications.properties || alerts.properties as nproperties').
      joins(:notification)
  }

  scope :another, ->(attribute, attr_id, user_id, notification_type) {
    joins([:notification, :user]).
      where('(notifications.properties -> ?) = ? and notifications.notification_type_id in (?) and users.id = ?',
            attribute,
            attr_id.to_s,
            notification_type,
            user_id).
      readonly(false)
  }

  scope :another_unread, ->(attribute, attr_id, user_id, notification_type) {
    another(attribute, attr_id, user_id, notification_type).where(alerts: {checked: false})
  }

  has_one :notification_type, through: :notification
  has_one :notification_category, through: :notification_type

  before_create :set_counter
  before_create :continue?
  after_create :increase_proposal_counter

  after_commit :send_email, on: :create
  after_commit :private_pub, on: :create
  after_commit :complete_alert_job, on: :create

  def alert_job
    @alert_job ||= AlertJob.find_by(jid: jid)
  end

  def data
    ret = nproperties.symbolize_keys
    ret[:count] = ret[:count].to_i
    ret
  end

  def data=(data)
    self.properties = data
  end

  def email_subject
    notification.email_subject
  end

  def check!
    update(checked: true, checked_at: Time.now)
  end

  def self.check_all
    update_all(checked: true, checked_at: Time.now)
  end

  def message
    extension = ".#{data[:extension]}" if data[:extension]
    I18n.t("db.#{notification_type.class.class_name.tableize}.#{notification_type.name}.message#{extension}", data)
  end

  def increase_count!
    self.properties_will_change! # TODO: bugfix on Rails 4. to remove when patched
    count = properties['count'] ? properties['count'].to_i : 1
    properties['count'] = count + 1
    save!
  end

  def soft_delete
    update_attributes!(deleted: true, deleted_at: Time.now)
  end

  def self.soft_delete_all
    update_all(deleted: true, deleted_at: Time.now)
  end

  protected

  def continue?
    !alert_job.canceled? && !acked?
  end

  def set_counter
    properties['count'] = alert_job.accumulated_count
  end

  def increase_proposal_counter
    @pa = ProposalAlert.find_or_create_by(proposal_id: notification.data[:proposal_id].to_i, user_id: user_id)
    @pa.increment!(:count)
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
    PrivatePub.publish_to("/notifications/#{user.id}", pull: 'hello') rescue nil
  end

  def complete_alert_job
    alert_job.complete(self)
  end

  def acked?
    trackable.acked_by?(user)
  end
end
