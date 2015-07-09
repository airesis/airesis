class AreaActionAbilitation < ActiveRecord::Base
  belongs_to :group_action, class_name: 'GroupAction', foreign_key: :group_action_id
  belongs_to :area_role, class_name: 'AreaRole', foreign_key: :area_role_id
  belongs_to :group_area, class_name: 'GroupArea', foreign_key: :group_area_id

  scope :by_group_area, lambda { |group_area|
                        where('group_area_id = ?', group_area.id)
                      }
end
