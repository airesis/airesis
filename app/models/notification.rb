class Notification < ActiveRecord::Base
  belongs_to :notification_type, class_name: 'NotificationType', foreign_key: :notification_type_id
  has_many :alerts, class_name: "Alert", dependent: :destroy
  has_many :notification_data, class_name: "NotificationData", dependent: :destroy, foreign_key: :notification_id

  def data
    ret = self.properties.symbolize_keys
    ret[:count] = ret[:count].to_i
    ret
    #unless @data
    #  @data = {}
    #  self.notification_data.each do |d|
    #    name = d.name.to_sym
    #    value = d.value
    #    value = (name == :count) ? d.value.to_i : d.value
    #    @data[name] = value
    #  end
    #end
    #@data
  end

  def data=(data)
    self.properties=data
    #data.each_key do |key|
    #  self.notification_data.build(name: key, value: data[key])
    #end
  end


  def email_subject
    group = data[:group]
    subject = group ? "[#{group}] " : ''
    if data[:extension]
      subject += I18n.t("db.#{self.notification_type.class.class_name.tableize}.#{self.notification_type.name}.email_subject.#{data[:extension]}", data)
    else
      subject += I18n.t("db.#{self.notification_type.class.class_name.tableize}.#{self.notification_type.name}.email_subject", data)
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
      read_attribute :message
    end
  end



end
