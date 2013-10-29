class DestroyAffinityTable < ActiveRecord::Migration
  def up
    drop_table :group_affinities
  end

  def down
  end
end
