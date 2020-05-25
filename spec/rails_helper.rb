require 'simplecov'

unless ENV['NO_COVERAGE']
  SimpleCov.start 'rails'
  SimpleCov.minimum_coverage 32.90
  SimpleCov.maximum_coverage_drop 0
end

ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
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

  config.include FactoryBot::Syntax::Methods
  config.include Devise::Test::IntegrationHelpers, type: :request
  config.include Warden::Test::Helpers
  config.include Capybara::Select2

  config.infer_spec_type_from_file_location!

  Warden.test_mode!
  OmniAuth.config.test_mode = true

  config.include Rails.application.routes.url_helpers

  config.before(:all, type: :system) do
    Capybara.server = :puma, { Silent: true }
  end

  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    driven_by :selenium_chrome_headless
  end

  config.after(:each, type: :system, js: true) do |example|
    errors = page.driver.browser.manage.logs.get(:browser)
    if errors.present? && example.metadata[:ignore_javascript_errors].blank?
      aggregate_failures 'javascript errors' do
        errors.each do |error|
          next if /Blocked attempt to show a 'beforeunload' confirmation panel/.match?(error.message)
          next if /connect.facebook.net/.match?(error.message)

          # TODO: should not happen
          next if /Cannot read property 'getSelectedElement' of null/.match?(error.message)
          # TODO: should not happen
          next if /FormValidation.Framework.Bootstrap/.match?(error.message)
          expect(error.level).not_to eq('SEVERE'), error.message
          next unless error.level == 'WARNING'

          warn 'WARN: javascript warning'
          warn error.message
        end
      end
    end
  end

  config.before do |x|
    Rails.logger.debug("RSpec #{x.metadata[:location]} #{x.metadata[:description]}")
  end
end

RSpec::Matchers.define :safe_include do |expected|
  match { |actual| actual.include?(CGI.escapeHTML(expected)) }
end
