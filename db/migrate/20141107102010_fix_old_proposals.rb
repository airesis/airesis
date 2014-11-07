class FixOldProposals < ActiveRecord::Migration
  def change
    Proposal.public.in_valutation.joins(:quorum).where(quorums: {type: 'OldQuorum'}).readonly(false).each do |proposal|
      if proposal.participants_count > 3
        proposal.check_phase(true)
      else
        proposal.destroy
      end
    end
  end
end
