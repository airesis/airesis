class CounterCachesForGroup < ActiveRecord::Migration
  def up
    add_column :groups, :proposals_count, :integer, default: 0
    Group.all.each do |b|
      execute "update groups set proposals_count = #{b.proposals.count} where id = #{b.id}"
    end
  end

  def down
    remove_column :groups, :proposals_count
  end
end
