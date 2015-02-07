ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'database_cleaner'
require 'sidekiq/testing'
require 'sunspot_test/rspec'

DEBUG=false
unless DEBUG
  require 'capybara-screenshot/rspec'
end

#Sidekiq::Testing.inline!

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|


  config.use_transactional_fixtures = false

  excluded_tables = %w[comunes continentes continente_translations statos stato_translations regiones regione_translations provincias provincia_translations event_types group_actions group_participation_request_statuses notification_categories notification_types proposal_categories proposal_states proposal_types ranking_types tutorials steps user_types participation_roles action_abilitations vote_types proposal_votation_types configurations sys_currencies sys_locales sys_movement_types]

  config.before(:each) do
    ActionMailer::Base.deliveries.clear
    Sidekiq::Worker.clear_all
  end

  config.before(:each) do
    I18n.locale = I18n.default_locale = :en
    DatabaseCleaner.strategy = :deletion, {:except => excluded_tables}
    DatabaseCleaner.start
    if Capybara.current_driver == :rack_test
    else
      #page.driver.allow_url
    end

    Proposal.remove_all_from_index!
    if BestQuorum.count == 0
      BestQuorum.create([{name: "1 giorno", percentage: nil, minutes_m: 0, hours_m: 0, days_m: 1, good_score: 50, bad_score: 50, vote_percentage: 0, vote_minutes: nil, vote_good_score: 50, t_percentage: "s", t_minutes: "s", t_good_score: "s", t_vote_percentage: "s", t_vote_minutes: "f", t_vote_good_score: "s", public: true, seq: 1},
                         {name: "3 giorni", percentage: nil, minutes_m: 0, hours_m: 0, days_m: 3, good_score: 50, bad_score: 50, vote_percentage: 0, vote_minutes: nil, vote_good_score: 50, t_percentage: "s", t_minutes: "s", t_good_score: "s", t_vote_percentage: "s", t_vote_minutes: "f", t_vote_good_score: "s", public: true, seq: 2},
                         {name: "7 giorni", percentage: nil, minutes_m: 0, hours_m: 0, days_m: 7, good_score: 50, bad_score: 50, vote_percentage: 0, vote_minutes: nil, vote_good_score: 50, t_percentage: "s", t_minutes: "s", t_good_score: "s", t_vote_percentage: "s", t_vote_minutes: "f", t_vote_good_score: "s", public: true, seq: 3},
                         {name: "15 giorni", percentage: nil, minutes_m: 0, hours_m: 0, days_m: 15, good_score: 50, bad_score: 50, vote_percentage: 0, vote_minutes: nil, vote_good_score: 50, t_percentage: "s", t_minutes: "s", t_good_score: "s", t_vote_percentage: "s", t_vote_minutes: "f", t_vote_good_score: "s", public: true, seq: 4},
                         {name: "30 giorni", percentage: nil, minutes_m: 0, hours_m: 0, days_m: 30, good_score: 50, bad_score: 50, vote_percentage: 0, vote_minutes: nil, vote_good_score: 50, t_percentage: "s", t_minutes: "s", t_good_score: "s", t_vote_percentage: "s", t_vote_minutes: "f", t_vote_good_score: "s", public: true, seq: 5}])
      admin = ParticipationRole.find(2)
      ActionAbilitation.create(GroupAction.all.map { |group_action| {group_action: group_action, participation_role: admin} })
      #ActiveRecord::Base.connection.execute('ALTER SEQUENCE participation_roles_id_seq RESTART WITH 3')
    end
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.order = "random"

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
      "#{example.description.gsub(' ', '-').gsub(/^.*\/spec\//, '').gsub("'",'')}"
    end
    Capybara::Screenshot.append_timestamp = false
  end
end
