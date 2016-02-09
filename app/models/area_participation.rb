class AreaParticipation < ActiveRecord::Base
  belongs_to :user, class_name: 'User', foreign_key: :user_id
  belongs_to :area_role, class_name: 'AreaRole', foreign_key: :area_role_id
  belongs_to :group_area, class_name: 'GroupArea', foreign_key: :group_area_id
end
