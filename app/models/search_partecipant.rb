class SearchPartecipant < ActiveRecord::Base
  belongs_to :group


  def results
    if !self.status_id.present? || self.status_id == GroupPartecipationRequestStatus::ACCEPTED
      ret = self.group.group_partecipations.joins(:user)
      ret = ret.where(:partecipation_role_id => self.role_id) if self.role_id.present?
      ret = ret.where(["upper(users.name) like '%' || upper(:key) || '%' or upper(users.surname) like '%' || upper(:key) || '%'", key: self.keywords]) if self.keywords.present?
      ret = ret.joins("join group_partecipation_requests gpr on (gpr.user_id = group_partecipations.user_id and gpr.group_id = group_partecipations.group_id)").where(["gpr.group_partecipation_request_status_id = ?", self.status_id]) if self.status_id.present?
      ret
    else
      ret = self.group.partecipation_requests.where(:group_partecipation_request_status_id => self.status_id)
      ret
    end
  end
end
