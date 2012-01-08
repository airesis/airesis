scheduler = Rufus::Scheduler.start_new

scheduler.chron("00 20 * * * ") do
   puts "Running scheduled task"
   AdminHelper.change_proposals_state
end 