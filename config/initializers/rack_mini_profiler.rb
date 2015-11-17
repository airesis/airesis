require 'rack-mini-profiler'

Rack::MiniProfiler.config.position = 'right'
Rack::MiniProfiler.config.start_hidden = false
# initialization is skipped so trigger it
Rack::MiniProfilerRails.initialize!(Rails.application)
