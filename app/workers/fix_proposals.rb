class FixProposals
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { hourly }
  sidekiq_options queue: :low_priority

  def perform(*_args)
    # check all proposals in debate and tim expired and close the debate
    Proposal.invalid_debate_phase.each(&:check_phase)

    # check all proposals waiting and put them in votation
    Proposal.invalid_waiting_phase.each do |proposal| # per ciascuna proposta da chiudere
      EventsWorker.new.start_votation(proposal.vote_period.id)
    end

    # check all proposals in votation that has to be closed but are still in votation and the period has passed
    Proposal.invalid_vote_phase.each(&:close_vote_phase)
  end
end
