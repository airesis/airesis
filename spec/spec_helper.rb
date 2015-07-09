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

  Capybara::Webkit.configure do |config|
    config.allow_url('pbs.twimg.com')
    config.allow_url('syndication.twitter.com')
    config.allow_url('platform.twitter.com')
    config.allow_url('platform.twitter.com')

    config.allow_url('www.gravatar.com')

    config.allow_url('maps.googleapis.com')
    config.allow_url('apis.google.com')
    config.allow_url('oauth.googleusercontent.com')
    config.allow_url('ssl.gstatic.com')
    config.allow_url('maps.gstatic.com')
    config.allow_url('www.google.com')
    config.allow_url('csi.gstatic.com')
    config.allow_url('mt0.googleapis.com')
    config.allow_url('mt1.googleapis.com')
    config.allow_url('fonts.googleapis.com')

    config.allow_url('connect.facebook.net/en/sdk.js')
    config.allow_url('fbstatic-a.akamaihd.net')
    config.allow_url('graph.facebook.com')
    config.allow_url('connect.facebook.net')
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
