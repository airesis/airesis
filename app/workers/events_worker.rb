class EventsWorker
  include Sidekiq::Worker, GroupsHelper, NotificationHelper, Rails.application.routes.url_helpers, ProposalsModule
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
    counter = 0
    event = Event.find(event_id)
    proposals = event.proposals
    proposals.each do |proposal|
      proposal.proposal_state_id = ProposalState::VOTING
      counter+=1
      proposal.save!
      vote_data = proposal.vote
      unless vote_data #se non ha i dati per la votazione creali
        vote_data = ProposalVote.new(proposal_id: proposal.id, positive: 0, negative: 0, neutral: 0)
        vote_data.save!
      end
      proposal.private ?
          notify_proposal_in_vote(proposal, proposal.presentation_groups.first,proposal.presentation_areas.first) :
          notify_proposal_in_vote(proposal)

      ProposalsWorker.perform_at(event.endtime - 24.hours, {action: ProposalsWorker::LEFT24VOTE, proposal_id: proposal.id}) if (event.duration/60) > 1440
      ProposalsWorker.perform_at(event.endtime - 1.hour, {action: ProposalsWorker::LEFT1VOTE, proposal_id: proposal.id}) if (event.duration/60) > 60

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
