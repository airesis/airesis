module Frm
  class ModeratorGroup < FrmTable
    belongs_to :forum, inverse_of: :moderator_groups
    belongs_to :frm_mod, class_name: 'Frm::Mod', foreign_key: 'group_id'
  end
end
