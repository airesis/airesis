class Alert < ActiveRecord::Base
  belongs_to :user, class_name: 'User', foreign_key: :user_id
  belongs_to :notification, class_name: 'Notification', foreign_key: :notification_id

  default_scope -> {select('alerts.*, notifications.properties || alerts.properties as nproperties').joins(:notification)}

  scope :another, ->(attribute,attr_id,user_id,notification_type) {joins([:notification, :user]).where(["(notifications.properties -> ?) = ? and notifications.notification_type_id in (?) and users.id = ?", attribute,attr_id.to_s, notification_type, user_id]).readonly(false)}

  scope :another_unread, ->(attribute,attr_id,user_id,notification_type) { another(attribute,attr_id,user_id,notification_type).where('alerts.checked = false')}

  #store_accessor :properties, :ncount

  has_one :notification_type, through: :notification
  has_one :notification_category, through: :notification_type

  after_create :increase_counter

  after_commit :send_email, on: :create

  def data
    ret = self.nproperties.symbolize_keys
    ret[:count] = ret[:count].to_i
    ret
  end

  def data=(data)
    self.properties=data
  end

  def email_subject
    self.notification.email_subject
  end


  def message
    super.html_safe
  end


  def check!
    self.update_attributes({checked: true, checked_at: Time.now})
    if proposal_id = self.data[:proposal_id]
      ProposalAlert.find_by_proposal_id_and_user_id(proposal_id.to_i, self.user_id).decrement!(:count)
    end
  end


  def self.check_all
    self.update_all({checked: true, checked_at: Time.now})
    self.all.each do |alert|
      if proposal_id = alert.data[:proposal_id]
        alert = ProposalAlert.find_by(proposal_id: proposal_id.to_i, user_id: alert.user_id)
        alert.decrement!(:count) if alert
      end
    end
  end

  def message
    if data[:i18n]     #todo 'if' added for back support
      if data[:extension]
        I18n.t("db.#{self.notification_type.class.class_name.tableize}.#{self.notification_type.name}.message.#{data[:extension]}", data)
      else
        I18n.t("db.#{self.notification_type.class.class_name.tableize}.#{self.notification_type.name}.message", data)
      end
    else
      self.notification.message
    end
  end


  def increase_count!
    self.properties_will_change!  #TODO bugfix on Rails 4. to remove when patched
    count = self.properties['count'] ? self.properties['count'].to_i : 1
    self.properties['count'] = count+1
    self.save!
  end

  def soft_delete
    self.update_attributes!({deleted: true, deleted_at: Time.now})
  end

  def self.soft_delete_all
    self.update_all({deleted: true, deleted_at: Time.now})
  end


  protected

  def increase_counter
    @pa = ProposalAlert.find_or_create_by(proposal_id: self.notification.data[:proposal_id].to_i, user_id: self.user_id)
    @pa.increment!(:count)
  end

  def send_email
    if !self.user.blocked? && (!self.user.blocked_email_notifications.include? self.notification_type) && self.user.email
      ResqueMailer.delay_for(2.minutes).notification(self.id)
    end
  end
end
