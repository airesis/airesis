class EventsWorker
  include Sidekiq::Worker, GroupsHelper, Rails.application.routes.url_helpers, ProposalsHelper

  sidekiq_options queue: :high_priority

  STARTVOTATION='startvotation'
  ENDVOTATION='endvotation'


  def perform(*args)
    params = args[0]
    case params['action']
      when STARTVOTATION
        start_votation(params['event_id'])
      when ENDVOTATION
        end_votation(params['event_id'])
      else
        puts "==Action not found!=="
    end
  end

  #fa partire la votazione di una proposta
  def start_votation(event_id)
    event = Event.find(event_id)
    event.start_votation
  end

  #terminate proposal votation
  def end_votation(event_id)
    event = Event.find(event_id)
    proposals = event.proposals
    proposals.each do |proposal|
        proposal.close_vote_phase
    end
  end



end
