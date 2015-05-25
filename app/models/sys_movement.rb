class SysMovement < ActiveRecord::Base
  validates_presence_of :sys_movement_type_id

  belongs_to :currency, class_name: 'SysCurrency', foreign_key: :sys_currency_id
  belongs_to :user
  belongs_to :type, class_name: 'SysMovementType', foreign_key: :sys_movement_type_id


  scope :income, -> { where(sys_movement_type_id: SysMovementType::INCOME) }
  scope :outcome, -> { where(sys_movement_type_id: SysMovementType::OUTCOME) }
end
