class RemoveRankingTypes < ActiveRecord::Migration[6.0]
  def change
    remove_foreign_key :proposal_comment_rankings, :ranking_types
    drop_table :ranking_types
  end
end
