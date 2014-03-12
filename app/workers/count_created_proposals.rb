class CountCreatedProposals
  include Sidekiq::Worker
  sidekiq_options :queue => :low_priority

  def perform(*args)
    start = Time.now.utc.at_beginning_of_day
    fin = (Time.now - 1.day).utc.at_beginning_of_day
    puts "Start: #{start}"
    puts "End: #{fin}"
    num = Proposal.count(:conditions => ["created_at < ? and created_at >= ?", start , fin])

    time = (Time.now).at_beginning_of_day
    StatNumProposal.create(date: time, value: num, year: time.year, month: time.month, day: time.day)
  end

end
