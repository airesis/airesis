class OldProposalsAreAnonimous < ActiveRecord::Migration
  def up
    Proposal.update_all anonima: true
    #fix categoria errata
    Proposal.where(proposal_category_id: 25).update_all(proposal_category_id: 8)
    ProposalCategory.destroy_all(id: 25)
  end

  def down
  end
end
