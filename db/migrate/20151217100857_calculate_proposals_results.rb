class CalculateProposalsResults < ActiveRecord::Migration
  def change
    Proposal.voted.
      joins(:solutions).
      group('proposals.id').
      having('count(solutions.*) > 1').count.map do |proposal_id, count|
      proposal = Proposal.find(proposal_id)
      proposal.create_proposal_votation_result!(data: SchulzeSolver.new(proposal).calculate)
    end
  end
end
