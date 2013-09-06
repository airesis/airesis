class NotificationType < ActiveRecord::Base
  #translates :description, :email_subject


  NEW_CONTRIBUTES = 1
  TEXT_UPDATE = 2
  CHANGE_STATUS = 4
  NEW_CONTRIBUTES_MINE = 5
  CHANGE_STATUS_MINE = 6
  AVAILABLE_AUTHOR = 22
  UNINTEGRATED_CONTRIBUTE = 25
  NEW_BLOG_COMMENT = 26


  belongs_to :notification_category, :class_name => 'NotificationCategory', :foreign_key => :notification_category_id
  has_many :blocked_alerts, :class_name => 'BlockedAlert'
  has_many :notifications, :class_name => 'Notification'
  has_many :blockers, :through => :blocked_alerts, :class_name => 'User', :source => :user

  def description
    I18n.t("db.#{self.class.class_name.tableize}.#{self.short}.description")
  end

  def email_subject
    I18n.t("db.#{self.class.class_name.tableize}.#{self.short}.email_subject")
  end
end
