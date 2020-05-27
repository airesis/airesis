require 'rspec/retry'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.run_all_when_everything_filtered = true

  config.disable_monkey_patching!

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.profile_examples = 5

  config.order = :random

  Kernel.srand config.seed

  if ENV['CI'] == 'true'
    config.verbose_retry = true
    config.around do |ex|
      ex.run_with_retry retry: 2
    end

    # callback to be run between retries
    config.retry_callback = proc do |ex|
      # run some additional clean up task - can be filtered by example metadata
      Capybara.reset! if ex.metadata[:js]
    end
  end
end
