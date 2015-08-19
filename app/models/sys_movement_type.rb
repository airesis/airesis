class SysMovementType < ActiveRecord::Base
  has_many :sys_movements

  INCOME = 1
  OUTCOME = 2
end
