module ProposalsModule
  
  #verifica se è necessario passare alla fase di votazione
  #una proposta attualmente in fase di valutazione e dibattito
  def check_phase(proposal)
    puts "controllo fase proposta " + proposal.id.to_s
    quorum = proposal.quorum
    passed = false
    timepassed = (!quorum.ends_at || Time.now > quorum.ends_at)
    vspassed = (!quorum.valutations || proposal.valutations >= quorum.valutations)
    #se erano definiti entrambi i parametri
    if (quorum.ends_at && quorum.valutations)
      puts "due controlli definiti"
      if (quorum.or?)
        passed = (timepassed || vpassed)
      else (quorum.and?)
        passed = (timepassed && vpassed)
      end
    else #altrimenti era definito solo uno dei due, una delle due variabili 
      puts "solo un controllo definito"
      passed = (timepassed && vpassed)
    end
    
    puts "la proposta ha passato?" + passed.to_s
    if (passed)
      if (proposal.rank >= quorum.good_score)
        proposal.proposal_state_id = PROP_WAIT_DATE  #metti la proposta in attesa di una data per la votazione
        notify_proposal_ready_for_vote(proposal)
      elsif (proposal.rank < quorum.bad_score)
        proposal.proposal_state_id = PROP_RESP
        notify_proposal_rejected(proposal)
      end 
      proposal.save
      proposal.reload
    end
  end
end
