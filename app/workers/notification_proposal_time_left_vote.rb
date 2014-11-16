class NotificationProposalTimeLeftVote < NotificationProposalTimeLeft
  
  def receivers(proposal)
    return proposal.group_area.scoped_participants(GroupAction::PROPOSAL_VOTE) if proposal.group_area
    return proposal.group.scoped_participants(GroupAction::PROPOSAL_VOTE) if proposal.group
    proposal.participants
  end
end
