class EventsWorker
  include GroupsHelper, NotificationHelper, Rails.application.routes.url_helpers
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
    event = Event.find(event_id)
    proposals = event.proposals
    proposals.each do |proposal|
      proposal.proposal_state_id = ProposalState::VOTING
      counter+=1
      proposal.save!
      vote_data = proposal.vote
      unless vote_data #se non ha i dati per la votazione creali
        vote_data = ProposalVote.new(:proposal_id => proposal.id, :positive => 0, :negative => 0, :neutral => 0)
        vote_data.save!
      end
      proposal.private ?
          notify_proposal_in_vote(proposal, proposal.presentation_groups.first,proposal.presentation_areas.first) :
          notify_proposal_in_vote(proposal)

      Resque.enqueue_at(event.ends_at - 24.hours, ProposalsWorker, {:action => ProposalsWorker::LEFT24VOTE, :proposal_id => @proposal.id}) if (event.duration/60) > 1440
      Resque.enqueue_at(event.ends_at - 1.hour, ProposalsWorker, {:action => ProposalsWorker::LEFT1VOTE, :proposal_id => @proposal.id}) if (event.duration/60) > 60

    end #end each
  end

  #terminate proposal votation
  def end_votation(event_id)
    event = Event.find(event_id)
    proposals = event.proposals
    proposals.each do |proposal|
      if proposal.is_schulze?
        vote_data_schulze = proposal.schulze_votes
        Proposal.transaction do
          votesstring = ""; #stringa da passare alla libreria schulze_vote per calcolare il punteggio
          vote_data_schulze.each do |vote|
            #in ogni riga inserisco la mappa del voto ed eventualmente il numero se più di un utente ha espresso la stessa preferenza
            vote.count > 1 ? votesstring += "#{vote.count}=#{vote.preferences}\n" : votesstring += "#{vote.preferences}\n"
          end
          num_solutions = proposal.solutions.count
          vs = SchulzeBasic.do votesstring, num_solutions
          solutions_sorted = proposal.solutions.sort { |a, b| a.id <=> b.id } #ordino le soluzioni secondo l'id crescente (così come vengono restituiti dalla libreria)
          solutions_sorted.each_with_index do |c, i|
            c.schulze_score = vs.ranks[i].to_i
            c.save!
          end
          proposal.proposal_state_id = ProposalState::ACCEPTED
        end #fine transazione
      else
        vote_data = proposal.vote
        positive = vote_data.positive
        negative = vote_data.negative
        neutral = vote_data.neutral
        votes = positive + negative + neutral
        if positive > negative #se ha avuto più voti positivi allora diventa ACCETTATA
          proposal.proposal_state_id = ProposalState::ACCEPTED
        elsif positive <= negative #se ne ha di più negativi allora diventa RESPINTA
          proposal.proposal_state_id = ProposalState::REJECTED
        end
      end
      proposal.save!
      proposal.private ?
          notify_proposal_voted(proposal, proposal.presentation_groups.first,proposal.presentation_areas.first) :
          notify_proposal_voted(proposal)
    end #end each
  end



end
