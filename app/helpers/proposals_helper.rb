module ProposalsHelper

  def link_to_proposal(proposal, options={})
    raise "Invalid proposal" unless proposal
    link_to proposal.title, proposal.private? ? [proposal.presentation_groups.first,proposal] : proposal, options
  end

end
