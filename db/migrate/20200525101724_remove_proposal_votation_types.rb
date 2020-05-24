class RemoveProposalVotationTypes < ActiveRecord::Migration[6.0]
  def change
    remove_foreign_key :proposals, :proposal_votation_types
    drop_table :proposal_votation_types
  end
end
