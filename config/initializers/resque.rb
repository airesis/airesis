
if Rails.env.staging? || Rails.env.production?
  ENV["REDISTOGO_URL"] ||= "redis://redistogo:8f1bf5f0fedd10c7336d89bd46fbf963@barracuda.redistogo.com:9485/"
  uri = URI.parse(ENV["REDISTOGO_URL"])
  Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end