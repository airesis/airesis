class ProposalsWorker
  @queue = :proposals
    
  def self.perform
    puts "==Done!=="
  end
end
