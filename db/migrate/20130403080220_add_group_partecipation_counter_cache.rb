class AddGroupParticipationCounterCache < ActiveRecord::Migration
  def up
    add_column :groups, :group_participations_count, :integer, null: false, default: 1

    execute "update groups g set group_participations_count = (select count(*) from group_participations pt where pt.group_id = g.id)"

  end

  def down
    remove_column :groups, :group_participations_count
  end
end
