module ProposalsModule
  include GroupsHelper, NotificationHelper, ProposalsHelper

  #check if we have to close the dabate and pass to votation phase
  #accept to parameters: the proposal and a force end parameter to close the debate in any case
  def check_phase(proposal, force_end=false)
    return unless proposal.in_valutation? #if the proposal already passed this phase skip this check
    quorum = proposal.quorum
    if quorum
      quorum.check_phase(force_end)
    else
      proposal.update_attribute(:proposal_state_id,ProposalState::VOTING)
      vote_data = proposal.vote
      unless vote_data #se non ha i dati per raccogliere le firme creali
        vote_data = ProposalVote.new(proposal_id: proposal.id, positive: 0, negative: 0, neutral: 0)
        vote_data.save!
      end
    end
  end

  def close_vote_phase(proposal)
    quorum = proposal.quorum
    quorum.close_vote_phase

  end
end
