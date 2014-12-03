class CountCreatedProposals
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily.hour_of_day(1) }
  sidekiq_options queue: :low_priority

  def perform(*args)
    start = (Time.now - 1.day).utc.at_beginning_of_day
    fin = Time.now.utc.at_beginning_of_day
    num = Proposal.where(created_at: start..fin).count
    time = (Time.now).at_beginning_of_day
    StatNumProposal.create(date: time, value: num, year: time.year, month: time.month, day: time.day)
  end
end
