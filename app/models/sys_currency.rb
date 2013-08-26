class SysCurrency < ActiveRecord::Base
  has_many :sys_movements
end
