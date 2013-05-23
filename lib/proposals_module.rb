module ProposalsModule
  include NotificationHelper
  #verifica se è necessario passare alla fase di votazione
  #una proposta attualmente in fase di valutazione e dibattito
  def check_phase(proposal)
    return unless proposal.in_valutation? #if the proposal already passed this phase skip this check
    quorum = proposal.quorum
    passed = false
    timepassed = (!quorum.ends_at || Time.now > quorum.ends_at)
    vpassed = (!quorum.valutations || proposal.valutations >= quorum.valutations)
    #se erano definiti entrambi i parametri
    if quorum.ends_at && quorum.valutations

      if quorum.or?
        passed = (timepassed || vpassed)
      else quorum.and?
        passed = (timepassed && vpassed)
      end
    else #altrimenti era definito solo uno dei due, una delle due variabili
      passed = (timepassed && vpassed)
    end

    if passed
      if proposal.rank >= quorum.good_score
        proposal.proposal_state_id = PROP_WAIT_DATE  #metti la proposta in attesa di una data per la votazione
        proposal.private? ?
          notify_proposal_ready_for_vote(proposal,proposal.presentation_groups.first) :
          notify_proposal_ready_for_vote(proposal)
      elsif proposal.rank < quorum.bad_score
        proposal.proposal_state_id = PROP_RESP
        notify_proposal_rejected(proposal)
      end 
      proposal.save
      proposal.reload
    end
  end
end
