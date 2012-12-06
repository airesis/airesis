class ProposalsWorker
  @queue = :proposals
  
  def self.perform(*args)
    TestMailer.test.deliver
    puts "==Done!=="
    puts "args[0]: " + args[0].to_s
  end
end
