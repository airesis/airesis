ENV['RAILS_ENV'] ||= 'test'
require 'rails_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'database_cleaner'
require 'sidekiq/testing'
require 'simplecov'
require 'selenium/webdriver'
require 'capybara-screenshot/rspec' unless ENV['DISABLE_SCREENSHOTS']

SimpleCov.start 'rails'
SimpleCov.minimum_coverage 70
SimpleCov.maximum_coverage_drop 0

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  # The doc states, that the disable-gpu flag will some day not be necessary any more:
  # https://developers.google.com/web/updates/2017/04/headless-chrome
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w[headless disable-gpu window-size=1024,768] }
  )

  Capybara::Selenium::Driver.new app, browser: :chrome, desired_capabilities: capabilities
end

Capybara.javascript_driver = :headless_chrome

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.before(:each) do
    ActionMailer::Base.deliveries.clear
    Sidekiq::Worker.clear_all
    I18n.locale = I18n.default_locale = :'en-EU'
    # Proposal.remove_all_from_index!
  end

  # allowed_urls = %w(abs.twimg.com pbs.twimg.com syndication.twitter.com platform.twitter.com
  #                   static.xx.fbcdn.net external.xx.fbcdn.net scontent.xx.fbcdn.net
  #                   maps.googleapis.com apis.google.com oauth.googleusercontent.com ssl.gstatic.com maps.gstatic.com
  #                   www.google.com csi.gstatic.com mt0.googleapis.com mt1.googleapis.com mts0.googleapis.com
  #                   mts1.googleapis.com fonts.googleapis.com connect.facebook.net/en/sdk.js fbstatic-a.akamaihd.net
  #                   graph.facebook.com connect.facebook.net fbexternal-a.akamaihd.net
  #                   fbcdn-profile-a.akamaihd.net cdn.ckeditor.com fbcdn-photos-e-a.akamaihd.net
  #                   platform.twitter.com www.gravatar.com cdnjs.cloudflare.com calendar.google.com)

  # Capybara::Webkit.configure do |config|
  #   config.block_unknown_urls
  #   allowed_urls.each do |allowed_url|
  #     config.allow_url(allowed_url)
  #   end
  # end

  config.include FactoryGirl::Syntax::Methods

  config.include Devise::TestHelpers, type: :controller

  config.include Warden::Test::Helpers

  config.include Capybara::Select2

  config.infer_spec_type_from_file_location!

  Warden.test_mode!

  # loading seeds
  # config.include Rails.application.routes.url_helpers
  config.include Rails.application.routes.url_helpers

  # Capybara.javascript_driver = :webkit

  Capybara::Screenshot.register_driver(:headless_chrome) do |driver, path|
    driver.browser.save_screenshot(path)
  end

  Capybara::Screenshot.register_driver(:chrome) do |driver, path|
    driver.browser.save_screenshot(path)
  end

  Capybara::Screenshot.autosave_on_failure = true
  Capybara::Screenshot.append_timestamp = true
end

OmniAuth.config.test_mode = true
