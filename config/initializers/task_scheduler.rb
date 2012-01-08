scheduler = Rufus::Scheduler.start_new

scheduler.every("1d") do
   puts "Running scheduled task"
   AdminHelper.change_proposals_state
end 