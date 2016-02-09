require 'rack-mini-profiler'

Rack::MiniProfiler.config.position = 'left'
Rack::MiniProfiler.config.start_hidden = false
# initialization is skipped so trigger it
Rack::MiniProfilerRails.initialize!(Rails.application)
