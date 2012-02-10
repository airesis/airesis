scheduler = Rufus::Scheduler.start_new

scheduler.every("1440m") do
   puts "Running scheduled task"
   AdminHelper.change_proposals_state
end 

scheduler.every '10m' do
   puts "Keep up heroku ;)"
   require "net/http"
   require "uri"
   url = 'http://democracyonline.heroku.com'
   Net::HTTP.get_response(URI.parse(url))
end