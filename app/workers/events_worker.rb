class EventsWorker
  include GroupsHelper, NotificationHelper, Rails.application.routes.url_helpers, ProposalsModule
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
        close_vote_phase(proposal)
    end #end each
  end



end
