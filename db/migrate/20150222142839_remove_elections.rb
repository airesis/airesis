class RemoveElections < ActiveRecord::Migration
  def change
    drop_table :election_votes
    drop_table :schulze_votes
    drop_table :group_elections
    drop_table :supporters
    drop_table :simple_votes
    drop_table :candidates
    drop_table :elections
  end
end
