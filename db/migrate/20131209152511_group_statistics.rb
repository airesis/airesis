class GroupStatistics < ActiveRecord::Migration
  def up
    create_table :group_statistics do |t|
      t.integer :group_id, null: false
      t.float :good_score   #group average good score
      t.float :vote_good_score #group average votation good score

      t.float :valutations #group average participants
      t.float :vote_valutations #group average vote participants
      t.timestamps
    end

    Group.all.each do |group|
      GroupStatistic.create!(:group_id => group.id)
    end
  end

  def down
    drop_table :group_statistics
  end
end
