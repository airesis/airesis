class Notification < ActiveRecord::Base
  belongs_to :notification_type, :class_name => 'NotificationType', :foreign_key => :notification_type_id
  has_many :user_alerts, :class_name => "UserAlert", :dependent => :destroy
  has_many :notification_data, :class_name => "NotificationData", :dependent => :destroy, :foreign_key => :notification_id
  
  def data
    if !@data
      @data = {}
      self.notification_datas.each do |d|
        @data[d.name] = d.value
      end
    end
    return @data
  end
  
  def data=(data)
    data.each_key do |key|
      self.notification_data.build(:name => key, :value => data[key])
    end
  end
end
