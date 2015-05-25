class RemoveProposalWatches < ActiveRecord::Migration
  def change
    drop_table :proposal_watches do |t|

    end
  end
end
