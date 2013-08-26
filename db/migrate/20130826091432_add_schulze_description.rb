class AddSchulzeDescription < ActiveRecord::Migration
  def up
    add_column :user_votes, :vote_schulze_desc, :string, limit: 2000
  end

  def down
    remove_column :user_votes, :vote_schulze_desc
  end
end
