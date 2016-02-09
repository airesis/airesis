class AreaActionAbilitation < ActiveRecord::Base
  belongs_to :group_action
  belongs_to :area_role
  belongs_to :group_area
end
