class Notification < ActiveRecord::Base
  belongs_to :notification_type
  has_many :alerts, dependent: :destroy
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
    extension = ".#{data[:extension]}" if data[:extension]
    subject += I18n.t("db.#{notification_type.class.class_name.tableize}.#{notification_type.name}.email_subject#{extension}", data)
  end

  def message
    extension = ".#{data[:extension]}" if data[:extension]
    I18n.t("db.#{notification_type.class.class_name.tableize}.#{notification_type.name}.message#{extension}", data)
  end
end
