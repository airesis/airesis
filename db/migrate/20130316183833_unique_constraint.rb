class UniqueConstraint < ActiveRecord::Migration
  def up
    add_index :proposal_presentations, [:user_id,:proposal_id], unique: true
  end

  def down
  end
end
