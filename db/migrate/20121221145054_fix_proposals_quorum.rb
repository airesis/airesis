class FixProposalsQuorum < ActiveRecord::Migration
  def up
    Proposal.all.each do |p|
      q = p.quorum
      if (q.valutations == 0)
        q.update_attribute(:valutations,1)
      end
    end
  end

  def down
  end
end
