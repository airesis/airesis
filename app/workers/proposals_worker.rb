class ProposalsWorker
  include ProposalsModule, NotificationHelper, Rails.application.routes.url_helpers
  @queue = :proposals
  
  ENDTIME='endtime'

  def self.perform(*args)
    params = args[0]
    puts params.to_s
    puts 'action: ' + params['action'].to_s
    case params['action']
	when ENDTIME
          ProposalsWorker.new.end_proposal(params['proposal_id'])
	else
	 puts "==Action not found!=="
    end
    TestMailer.test.deliver
    puts "==Done!=="
  end

  #fa terminare la fase di valutazione di una proposta
  def end_proposal(proposal_id)
   proposal = Proposal.find_by_id(proposal_id)
   check_phase(proposal)
  end

end
