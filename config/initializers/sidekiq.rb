Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL']}
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL']}
end

#Resque.schedule = YAML.load_file(File.join(File.dirname(__FILE__), '../resque_schedule.yml'))


#Resque::Failure::Multiple.configure do |config|
#  config.classes = [Resque::Failure::Redis, Resque::Failure::Notifier2]
#end

#Resque::Failure::Notifier2.configure do |config|
#  config.smtp = {address: EMAIL_ADDRESS, port: 587, user: EMAIL_USERNAME,secret: EMAIL_PASSWORD}
#  config.sender =  ERROR_SENDER
#  config.recipients = [ERROR_RECEIVER]
#end
