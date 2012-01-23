scheduler = Rufus::Scheduler.start_new

scheduler.every("1440m") do
   puts "Running scheduled task"
   AdminHelper.change_proposals_state
end 