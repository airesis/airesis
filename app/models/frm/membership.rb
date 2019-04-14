module Frm
  class Membership < FrmTable
    belongs_to :mod, foreign_key: :group_id
    belongs_to :member, class_name: 'User', inverse_of: :memberships
  end
end
