module Frm
  class ModeratorGroup < FrmTable
    belongs_to :forum, :inverse_of => :moderator_groups
    belongs_to :frm_group, class_name: 'Frm::Group', foreign_key: 'group_id'

    attr_accessible :group_id
  end
end
