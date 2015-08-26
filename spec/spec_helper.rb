require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'database_cleaner'
require 'sidekiq/testing'
require 'simplecov'
require 'sunspot_test/rspec'

require 'capybara-screenshot/rspec' unless ENV['DISABLE_SCREENSHOTS']

SimpleCov.start 'rails'
SimpleCov.minimum_coverage 70
SimpleCov.maximum_coverage_drop 0

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|

  config.use_transactional_fixtures = false

  config.before(:each) do
    ActionMailer::Base.deliveries.clear
    Sidekiq::Worker.clear_all
    I18n.locale = I18n.default_locale = :'en-EU'
    Proposal.remove_all_from_index!
  end

  allowed_urls = %w(abs.twimg.com pbs.twimg.com syndication.twitter.com platform.twitter.com
                    static.xx.fbcdn.net external.xx.fbcdn.net scontent.xx.fbcdn.net
                    maps.googleapis.com apis.google.com oauth.googleusercontent.com ssl.gstatic.com maps.gstatic.com
                    www.google.com csi.gstatic.com mt0.googleapis.com mt1.googleapis.com mts0.googleapis.com
                    mts1.googleapis.com fonts.googleapis.com connect.facebook.net/en/sdk.js fbstatic-a.akamaihd.net
                    graph.facebook.com connect.facebook.net fbexternal-a.akamaihd.net
                    fbcdn-profile-a.akamaihd.net cdn.ckeditor.com
                    platform.twitter.com www.gravatar.com )

  Capybara::Webkit.configure do |config|
    allowed_urls.each do |allowed_url|
      config.allow_url(allowed_url)
    end
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

  Capybara.javascript_driver = :webkit

  Capybara::Screenshot.autosave_on_failure = true unless ENV['DISABLE_SCREENSHOTS']
end

OmniAuth.config.test_mode = true
