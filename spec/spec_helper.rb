ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

require 'database_cleaner'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)


RSpec.configure do |config|

  config.use_transactional_fixtures = false

  config.before(:each) do
    if Capybara.current_driver == :rack_test
      DatabaseCleaner.strategy = :truncation
    else
      DatabaseCleaner.strategy = :truncation
    end
    DatabaseCleaner.start
    Rails.application.load_seed
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.order = "random"

  config.include FactoryGirl::Syntax::Methods

  config.include Warden::Test::Helpers
  Warden.test_mode!

   # loading seeds
  #config.include Rails.application.routes.url_helpers
  config.include Rails.application.routes.url_helpers

  Capybara.register_driver :selenium do |app|
    Capybara::Selenium::Driver.new(app, :browser => :chrome)
  end
end