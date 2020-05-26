class SearchParticipant < ApplicationRecord
  belongs_to :group

  def results
    if status_id.blank? || status_id.to_sym == :accepted
      ret = group.group_participations.joins(:user)
      ret = ret.where(participation_role_id: role_id) if role_id.present?
      if keywords.present?
        ret = ret.where(["upper(users.name) like '%' || upper(:key) || '%' or upper(users.surname) like '%' || upper(:key) || '%'", key: keywords])
      end
      if status_id.present?
        ret = ret.joins('join group_participation_requests gpr on (gpr.user_id = group_participations.user_id and gpr.group_id = group_participations.group_id)').where(['gpr.group_participation_request_status_id = ?', status_id])
      end

    else
      ret = group.participation_requests.where(group_participation_request_status_id: status_id)
    end
    ret.includes(:user).order('group_participations.created_at desc nulls last')
  end
end
