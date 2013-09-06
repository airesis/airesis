class Notification < ActiveRecord::Base
  belongs_to :notification_type, :class_name => 'NotificationType', :foreign_key => :notification_type_id
  has_many :user_alerts, :class_name => "UserAlert", :dependent => :destroy
  has_many :notification_data, :class_name => "NotificationData", :dependent => :destroy, :foreign_key => :notification_id

  def data
    unless @data
      @data = {}
      self.notification_data.each do |d|
        @data[d.name.to_sym] = d.value
      end
    end
    @data
  end

  def data=(data)
    data.each_key do |key|
      self.notification_data.build(:name => key, :value => data[key])
    end
  end

  def message
    #todo added for back support
    if data[:i18n]
      if data[:extension]
        I18n.t("db.#{self.notification_type.class.class_name.tableize}.#{self.notification_type.name}.message.#{data[:extension]}", data)
      else
        I18n.t("db.#{self.notification_type.class.class_name.tableize}.#{self.notification_type.name}.message", data)
      end
    else
      read_attribute :message
    end
  end
end
