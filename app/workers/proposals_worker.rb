class ProposalsWorker
  @queue = :proposals
  
  def self.perform(*args)
    TestMailer.test.deliver
    puts "==Done!=="
  end
end
