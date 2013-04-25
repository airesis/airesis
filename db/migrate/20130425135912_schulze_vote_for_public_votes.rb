class SchulzeVoteForPublicVotes < ActiveRecord::Migration
  def up
    add_column :user_votes, :vote_schulze, :string, limit: 255, null: true
    change_column :proposal_schulze_votes, :count, :integer, null: false, default: 0
  end

  def down
    remove_column :user_votes, :vote_schulze
  end
end
