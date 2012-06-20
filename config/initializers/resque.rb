module Resque

  #override
  def mongo=(server)
    case server
    when String
      @con = Mongo::Connection.from_uri(server)
      @db = @con.db('coorasse_resque')
      @mongo = @db.collection('monque')
      @workers = @db.collection('workers')
      @failures = @db.collection('failures')
      @stats = @db.collection('stats')

    end
  end
end


if Rails.env.staging? || Rails.env.production?
  #heroku conf
  #ENV["REDISTOGO_URL"] ||= "redis://redistogo:8f1bf5f0fedd10c7336d89bd46fbf963@barracuda.redistogo.com:9485/"
  #uri = URI.parse(ENV["REDISTOGO_URL"])
  #Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  
  
#Resque.redis = Redis.new(:host => '127.0.0.1', :port => '12712')
#Resque.redis = Redis.new(:path => '/home/coorasse/tmp/redis.sock')
Resque.mongo = ENV['airesis_prod_mongo_address']

  
end