AIRESIS_VERSION = '4.8.4'.freeze

if defined?(Raven)
  Raven.configure do |config|
    config.processors -= [Raven::Processor::PostData]
    config.release = AIRESIS_VERSION
  end
end
