module Frm
  class Membership < FrmTable
    belongs_to :group
    belongs_to :member, :class_name => 'User'

    attr_accessible :member_id, :group_id
  end
end
