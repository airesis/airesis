class FixLostProposals < ActiveRecord::Migration
  #destry all orphan proposals. proposals of groups that have been deleted. this version contains also a fix to this problem
  def up
    Proposal.where(:private => true).joins('left join group_proposals pg on proposals.id = pg.proposal_id').where('pg.id is null').destroy_all
  end

  def down
  end
end
