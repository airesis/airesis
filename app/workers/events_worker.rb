class EventsWorker
  include NotificationHelper, Rails.application.routes.url_helpers
  @queue = :events

  STARTVOTATION='startvotation'
  ENDVOTATION='endvotation'

  def self.perform(*args)
    params = args[0]
    case params['action']
    when STARTVOTATION
            EventsWorker.new.start_votation(params['event_id'])
    when ENDVOTATION
        EventsWorker.new.end_votation(params['event_id'])
    else
      puts "==Action not found!=="
    end
  end

  #fa partire la votazione di una proposta
  def start_votation(event_id)
   counter = 0
   event = Event.find_by_id(event_id)
   event.proposals.each do |proposal|
     proposal.proposal_state_id = ProposalState::VOTING
     counter+=1
     proposal.save
     vote_data = proposal.vote
     unless vote_data #se non ha i dati per la votazione creali
       vote_data = ProposalVote.new(:proposal_id => proposal.id, :positive => 0, :negative => 0, :neutral => 0)
       vote_data.save
     end
   end #end each
  end

  #fa terminare la votazione di una proposta
  def end_votation(event_id)
    event = Event.find_by_id(event_id)
    event.proposals.each do |proposal|
      vote_data = proposal.vote
      unless vote_data #se non ha i dati per la votazione creali
        vote_data = ProposalVote.new(:proposal_id => proposal.id, :positive => 0, :negative => 0, :neutral => 0)
        vote_data.save
      end
      positive = vote_data.positive
      negative = vote_data.negative
      neutral = vote_data.neutral
      votes = positive + negative + neutral
      if positive > negative  #se ha avuto più voti positivi allora diventa ACCETTATA
        proposal.proposal_state_id = PROP_ACCEPT
      elsif positive <= negative  #se ne ha di più negativi allora diventa RESPINTA
        proposal.proposal_state_id = PROP_RESP
      end
      proposal.save
    end #end each
  end

end
