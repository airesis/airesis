class DropGroupParticipationRequestStatuses < ActiveRecord::Migration[6.0]
  def change
    remove_foreign_key :group_participation_requests, :group_participation_request_statuses
    drop_table :group_participation_request_statuses
  end
end
