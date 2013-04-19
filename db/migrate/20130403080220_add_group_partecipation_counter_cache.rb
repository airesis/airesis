class AddGroupPartecipationCounterCache < ActiveRecord::Migration
  def up
    add_column :groups, :group_partecipations_count, :integer, null: false, default: 1

    execute "update groups g set group_partecipations_count = (select count(*) from group_partecipations pt where pt.group_id = g.id)"

  end

  def down
    remove_column :groups, :group_partecipations_count
  end
end
