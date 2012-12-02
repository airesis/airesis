class ModifyQuorums < ActiveRecord::Migration
  def up
    add_column :quorums, :started_at, :timestamp
    add_column :quorums, :ends_at, :timestamp
  end

  def down
    remove_column :quorums, :started_at
    remove_column :quorums, :ends_at
  end
end
