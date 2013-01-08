class ChangeProposalState
  
  def self.perform(*args)
    puts "Changing proposal state"
    counter = 0
    denied = 0
    accepted = 0
    #scorri le proposte in votazione che devono essere chiuse
    voting = Proposal.all(:joins => [:vote_period], :conditions => ['proposal_state_id = 4 and current_timestamp > events.endtime'], :readonly => false)
    puts "Proposte da chiudere:" + voting.join(",")
    voting.each do |proposal| #per ciascuna proposta da chiudere
      vote_data = proposal.vote 
      if (!vote_data) #se non ha i dati per la votazione creali
       vote_data = ProposalVote.new(:proposal_id => proposal.id, :positive => 0, :negative => 0, :neutral => 0)
       vote_data.save
      end
      positive = vote_data.positive
      negative = vote_data.negative
      neutral = vote_data.neutral
      votes = positive + negative + neutral
      if (positive > negative)  #se ha avuto più voti positivi allora diventa ACCETTATA
        proposal.proposal_state_id = PROP_ACCEPT
        accepted+=1
      elsif (positive <= negative)  #se ne ha di puù negativi allora diventa RESPINTA
        proposal.proposal_state_id = PROP_RESP
        denied+=1
      end  
     
      proposal.save
    
    end if voting
        
    #prendo tutte le proposte che ad oggi devono essere votate e le passo in stato IN VOTAZIONE
    events = Event.all(:conditions => ['event_type_id = 2 and current_timestamp between starttime and endtime and proposals.proposal_state_id = 3'], :include => [:proposals])
    
    events.each do |event|
      event.proposals.each do |proposal|
        proposal.proposal_state_id = PROP_VOTING
        counter+=1
        proposal.save
        vote_data = proposal.vote 
        if (!vote_data) #se non avesse i dati per la votazione creali
          vote_data = ProposalVote.new(:proposal_id => proposal.id, :positive => 0, :negative => 0, :neutral => 0)
          vote_data.save
        end        
      end
    end if events
    
    msg = denied.to_s + ' proposte sono state RESPINTE, ' + accepted.to_s + ' proposte sono state ACCETTATE, ' + counter.to_s + ' proposte sono passate in VOTAZIONE'
    puts msg
    ResqueMailer.admin_message(msg).deliver
  end

end
