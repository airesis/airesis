class AddVotesCounterCache < ActiveRecord::Migration
  def change
    add_column :proposals, :user_votes_count, :integer
    Proposal.find_each do |proposal|
      Proposal.reset_counters(proposal.id, :user_votes)
    end
  end
end
