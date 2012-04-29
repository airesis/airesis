scheduler = Rufus::Scheduler.start_new

scheduler.cron '0 1 * * *' do
   puts "Aggiorno lo stato delle proposte"
   AdminHelper.change_proposals_state
end 

scheduler.every '10m' do
   puts "Keep up heroku ;)"
   require "net/http"
   require "uri"
   url = 'http://democracyonline.heroku.com'
   Net::HTTP.get_response(URI.parse(url))
   
scheduler.cron '0 1 * * *' do
   puts "Cancello le vecchie notifiche"
   AdminHelper.delete_old_notifications
end    
   
end