RSpec.configure do |config|
  excluded_tables = %w(event_types group_participation_request_statuses notification_categories notification_types proposal_categories proposal_states proposal_types ranking_types tutorials steps user_types participation_roles vote_types proposal_votation_types configurations)

  config.before(:suite) do
    DatabaseCleaner.clean_with(:deletion, except: excluded_tables)
    Configuration.find_by(name: 'recaptcha').update_column(:value, 0)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :deletion, { except: excluded_tables }
  end

  config.before(:each, search: true) do
    DatabaseCleaner.strategy = :deletion, { except: excluded_tables }
  end

  config.before(:each, emails: true) do
    DatabaseCleaner.strategy = :deletion, { except: excluded_tables }
  end

  config.before(:each) do
    DatabaseCleaner.start
    load_countries
    # load_database
  end

  config.before(:each, seeds: true) do
    load_database
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end

  def load_countries
    a1 = Continent.create(description: 'Europe')
    SysLocale.create(key: 'en-EU', host: 'airesis.eu', territory: a1, default: true)
  end

  def load_municipalities
    a1 = Continent.first
    s1 = Country.create(description: 'Italy', continent_id: a1.id, sigla: 'IT', sigla_ext: 'ITA')
    r14 = Region.create(description: 'Emilia Romagna', country_id: s1.id, continent_id: a1.id)
    p1 = Province.create(description: 'Bologna', region_id: r14.id, country_id: s1.id, continent_id: a1.id, sigla: 'BO')
    Municipality.create(description: 'Bologna', province_id: p1.id, region_id: r14.id, country_id: s1.id, continent_id: a1.id, population: 371_217)
  end

  def load_database
    load_municipalities
    admin = ParticipationRole.create(name: 'amministratore', description: 'Amministratore')
    return unless BestQuorum.count == 0
    base_attrs = { percentage: nil, minutes_m: 0, hours_m: 0, good_score: 50, bad_score: 50, vote_percentage: 0,
                   vote_minutes: nil, vote_good_score: 50, t_percentage: 's', t_minutes: 's', t_good_score: 's',
                   t_vote_percentage: 's', t_vote_minutes: 'f', t_vote_good_score: 's', public: true }
    BestQuorum.create([base_attrs.merge(name: '1 giorno', days_m: 1, seq: 1),
                       base_attrs.merge(name: '3 giorni', days_m: 3, seq: 2),
                       base_attrs.merge(name: '7 giorni', days_m: 7, seq: 3),
                       base_attrs.merge(name: '15 giorni', days_m: 15, seq: 4),
                       base_attrs.merge(name: '30 giorni', days_m: 30, seq: 5)])
    GroupAction.all.each do |group_action|
      ActionAbilitation.create(group_action: group_action, participation_role: admin)
    end
    # ActiveRecord::Base.connection.execute('ALTER SEQUENCE participation_roles_id_seq RESTART WITH 3')
  end
end
