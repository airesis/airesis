class NotificationProposalRejected < NotificationSender

  def perform(proposal_id)
    elaborate(proposal_id)
  end

  def elaborate(proposal_id)
    proposal = Proposal.find(proposal_id)
    group = proposal.group
    group_area = proposal.group_area
  end
end
