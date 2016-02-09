class FixParticipationsCount < ActiveRecord::Migration
  def change
    change_column_default :groups, :group_participations_count, 0

    Group.all.each do |group|
      Group.reset_counters(group.id, :group_participations)
    end
  end
end
