ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'database_cleaner'
require 'sidekiq/testing'
require 'sunspot_test/rspec'

DEBUG=false
unless DEBUG
  require 'capybara-screenshot/rspec'
end

#Sidekiq::Testing.inline!

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|

  config.use_transactional_fixtures = false

  config.before(:each) do
    ActionMailer::Base.deliveries.clear
    Sidekiq::Worker.clear_all
    I18n.locale = I18n.default_locale = :en
    Proposal.remove_all_from_index!
  end

  config.before(:each, type: :feature) do
    page.driver.allow_url("https://apis.google.com/js/platform.js")
    page.driver.allow_url("www.gravatar.com")
    page.driver.allow_url("http://connect.facebook.net/en/sdk.js")
    page.driver.allow_url("http://platform.twitter.com")
    page.driver.allow_url("https://fbstatic-a.akamaihd.net")
    page.driver.allow_url("https://maps.googleapis.com")
  end

  config.order = 'random'

  config.include FactoryGirl::Syntax::Methods

  config.include Devise::TestHelpers, type: :controller

  config.include Warden::Test::Helpers

  config.include Capybara::Select2

  Warden.test_mode!

  # loading seeds
  #config.include Rails.application.routes.url_helpers
  config.include Rails.application.routes.url_helpers

  #Capybara.register_driver :selenium do |app|
  #  Selenium::WebDriver::Firefox::Binary.path='/opt/homebrew-cask/Caskroom/firefox/latest/Firefox.app/Contents/MacOS/firefox-bin'
  #  Capybara::Selenium::Driver.new(app, :browser => :firefox)
  #end

  unless DEBUG
    Capybara.javascript_driver = :webkit
    Capybara::Screenshot.autosave_on_failure = true
    Capybara::Screenshot.register_filename_prefix_formatter(:rspec) do |example|
      "screenshot_#{example.description.gsub(' ', '-').gsub(/^.*\/spec\//, '')}"
    end
    Capybara::Screenshot.append_timestamp = false
  end
end

OmniAuth.config.test_mode = true
