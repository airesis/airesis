class DefaultZeroGuests < ActiveRecord::Migration
  def up
     MeetingParticipation.find_all_by_guests(nil).each do |part|
      part.update_attribute(:guests,0)
    end
     change_column :meeting_participations, :guests, :integer, null: false, default: 0
  end

  def down
  end
end
