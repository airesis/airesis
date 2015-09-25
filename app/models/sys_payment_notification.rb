class SysPaymentNotification < ActiveRecord::Base
  belongs_to :payable, polymorphic: true
  serialize :params

  # after_create
end
