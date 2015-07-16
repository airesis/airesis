class GroupParticipation < ActiveRecord::Base
  include ImageHelper
  belongs_to :user, class_name: 'User', foreign_key: :user_id
  belongs_to :participation_role, class_name: 'ParticipationRole', foreign_key: :participation_role_id
  belongs_to :group, class_name: 'Group', foreign_key: :group_id, counter_cache: true
  belongs_to :acceptor, class_name: 'User', foreign_key: :acceptor_id

  after_destroy :remove_user_data

  PER_PAGE=12

  def as_admin?
    self == ParticipationRole.admin
  end

  protected

  #remove also the participation request and area participations
  def remove_user_data
    group_participation_request = GroupParticipationRequest.find_by(user_id: self.user_id, group_id: self.group_id)
    group_participation_request.destroy
    AreaParticipation.joins(group_area: :group).where(['groups.id = ? AND area_participations.user_id = ?', self.group_id, self.user_id]).readonly(false).destroy_all
  end
end
