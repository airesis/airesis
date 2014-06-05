class WrongNames < ActiveRecord::Migration
  def change
    rename_column :groups, :disable_partecipation_requests, :disable_participation_requests
    rename_column :request_votes, :group_partecipation_request_id, :group_participation_request_id
    rename_column :partecipation_roles, :parent_partecipation_role_id, :parent_participation_role_id
    rename_column :groups, :group_partecipations_count, :group_participations_count
    rename_column :groups, :partecipation_role_id, :participation_role_id
    rename_column :group_partecipations, :partecipation_role_id, :participation_role_id
    rename_column :group_partecipation_requests, :group_partecipation_request_status_id, :group_participation_request_status_id
    rename_column :action_abilitations, :partecipation_role_id, :participation_role_id

    rename_table :area_partecipations, :area_participations
    rename_table :group_partecipation_request_statuses, :group_participation_request_statuses
    rename_table :group_partecipation_requests, :group_participation_requests
    rename_table :group_partecipations, :group_participations
    rename_table :meeting_partecipations, :meeting_participations
    rename_table :search_partecipants, :search_participants
    rename_table :partecipation_roles, :participation_roles
  end
end
