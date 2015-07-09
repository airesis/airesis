class RemoveOldElectionData < ActiveRecord::Migration
  def change
    Event.where(event_type_id: [3,4]).destroy_all
  end
end
