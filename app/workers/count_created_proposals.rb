class CountCreatedProposals
  def perform(*_args)
    start = (Time.now - 1.day).utc.at_beginning_of_day
    fin = Time.now.utc.at_beginning_of_day
    num = Proposal.where(created_at: start..fin).count
    time = (Time.now).at_beginning_of_day
    StatNumProposal.create(date: time, value: num, year: time.year, month: time.month, day: time.day)
  end
end
