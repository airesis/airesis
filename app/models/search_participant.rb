class SearchParticipant < ActiveRecord::Base
  belongs_to :group
  belongs_to :group_participation_request_status, foreign_key: :status_id

  def results
    if !self.status_id.present? || self.status_id == GroupParticipationRequestStatus::ACCEPTED
      ret = self.group.group_participations.joins(:user)
      ret = ret.where(participation_role_id: self.role_id) if self.role_id.present?
      ret = ret.where(["upper(users.name) like '%' || upper(:key) || '%' or upper(users.surname) like '%' || upper(:key) || '%'", key: self.keywords]) if self.keywords.present?
      ret = ret.joins('join group_participation_requests gpr on (gpr.user_id = group_participations.user_id and gpr.group_id = group_participations.group_id)').where(['gpr.group_participation_request_status_id = ?', self.status_id]) if self.status_id.present?

    else
      ret = self.group.participation_requests.where(group_participation_request_status_id: self.status_id)
    end
    ret.includes(:user => :user_type).order('group_participations.created_at desc nulls last')
  end
end
