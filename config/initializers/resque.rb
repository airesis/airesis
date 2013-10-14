require 'resque'
require 'resque_scheduler'
require 'resque_scheduler/server'
require 'resque/failure/notifier2'
require 'resque/failure/multiple'
require 'resque/failure/redis'
Resque.redis = Redis.new(:host => '127.0.0.1', :port => '6379')
Resque.schedule = YAML.load_file(File.join(File.dirname(__FILE__), '../resque_schedule.yml'))


Resque::Failure::Multiple.configure do |config|
  config.classes = [Resque::Failure::Redis, Resque::Failure::Notifier2]
end

Resque::Failure::Notifier2.configure do |config|
  config.smtp = {:address => EMAIL_ADDRESS, :port => 587, :user => EMAIL_USERNAME,:secret => EMAIL_PASSWORD}
  config.sender =  ERROR_SENDER
  config.recipients = [ERROR_RECEIVER]
end