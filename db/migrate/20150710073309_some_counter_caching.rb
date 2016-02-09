class SomeCounterCaching < ActiveRecord::Migration
  def change
    add_column :groups, :meeting_organizations_count, :integer, null: false, default: 0
    Group.all.each do |group|
      Group.reset_counters(group.id, :meeting_organizations)
      Group.reset_counters(group.id, :group_proposals)
    end unless reverting?
  end
end
