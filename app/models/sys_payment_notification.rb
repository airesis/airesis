class SysPaymentNotification < ActiveRecord::Base
  belongs_to :sys_feature
  serialize :params

  #after_create
end
