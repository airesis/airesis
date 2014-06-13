module Frm
  class Membership < FrmTable
    belongs_to :group
    belongs_to :member, class_name: 'User'
  end
end
