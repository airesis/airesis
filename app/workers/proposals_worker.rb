class ProposalsWorker
  include ProposalsModule
  @queue = :proposals
  
  ENDTIME='endtime'

  def self.perform(*args)
    case args[:action]
	when ENDTIME
		end_proposal(args[:proposal_id])
	else
	 puts "==Action not found!=="
    end
    TestMailer.test.deliver
    puts "==Done!=="
  end

  protected
  
  #fa terminare la fase di valutazione di una proposta
  def end_proposal(proposal_id)
   proposal = Proposal.find_by_id(proposal_id)
   check_phase(proposal)
  end
end
