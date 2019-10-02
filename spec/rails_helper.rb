require 'simplecov'

unless ENV['NO_COVERAGE']
  SimpleCov.start 'rails'
  SimpleCov.minimum_coverage 34.70
  SimpleCov.maximum_coverage_drop 0
end

ENV['RAILS_ENV'] ||= 'test'
require 'rails_helper'
require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'
require 'sidekiq/testing'
require 'capybara/rspec'
require 'capybara/rails'
require 'selenium/webdriver'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec.configure do |config|
  config.use_transactional_fixtures = true

  config.before do
    ActionMailer::Base.deliveries.clear
    Sidekiq::Worker.clear_all
    I18n.locale = I18n.default_locale = :'en-EU'
  end

  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    driven_by :selenium_chrome_headless
  end

  config.include FactoryBot::Syntax::Methods

  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::IntegrationHelpers, type: :request

  config.include Warden::Test::Helpers

  config.include Capybara::Select2

  config.infer_spec_type_from_file_location!

  Warden.test_mode!
  OmniAuth.config.test_mode = true

  config.include Rails.application.routes.url_helpers

  config.around :each, :js do |ex|
    ex.run_with_retry retry: 3
  end
end
