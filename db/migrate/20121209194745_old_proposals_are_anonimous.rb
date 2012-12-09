class OldProposalsAreAnonimous < ActiveRecord::Migration
  def up
    Proposal.update_all :anonima => true
  end

  def down
  end
end
