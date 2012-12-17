require 'resque'
require 'resque_scheduler'
require 'resque_scheduler/server'
Resque.redis = Redis.new(:host => '127.0.0.1', :port => '6379')
Resque.schedule = YAML.load_file(File.join(File.dirname(__FILE__), '../resque_schedule.yml'))
