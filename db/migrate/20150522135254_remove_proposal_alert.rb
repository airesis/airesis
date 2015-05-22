class RemoveProposalAlert < ActiveRecord::Migration
  def change
    drop_table :proposal_alerts
  end
end
