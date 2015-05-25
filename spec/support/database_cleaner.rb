RSpec.configure do |config|
  excluded_tables = %w(event_types group_actions group_participation_request_statuses notification_categories notification_types proposal_categories proposal_states proposal_types ranking_types tutorials steps user_types participation_roles action_abilitations vote_types proposal_votation_types configurations sys_currencies sys_locales sys_movement_types)

  config.before(:suite) do
    DatabaseCleaner.clean_with(:deletion, except: excluded_tables)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :deletion, {except: excluded_tables}
  end

  config.before(:each, search: true) do
    DatabaseCleaner.strategy = :deletion, {except: excluded_tables}
  end

  config.before(:each, emails: true) do
    DatabaseCleaner.strategy = :deletion, {except: excluded_tables}
  end

  config.before(:each) do
    DatabaseCleaner.start

    a1 = Continente.create(description: "Europe")
    s1 = Stato.create(description: "Italy", continente_id: a1.id, sigla: "IT", sigla_ext: "ITA")
    r14 = Regione.create(description: "Emilia Romagna", stato_id: s1.id, continente_id: a1.id)
    p1 = Provincia.create(description: "Bologna", regione_id: r14.id, stato_id: s1.id, continente_id: a1.id, sigla: "BO")
    Comune.create(description: "Bologna", provincia_id: p1.id, regione_id: r14.id, stato_id: s1.id, continente_id: a1.id, population: 371217)

    admin = ParticipationRole.create(name: 'amministratore', description: 'Amministratore')
    if BestQuorum.count == 0
      BestQuorum.create(name: '1 giorno', percentage: nil, minutes_m: 0, hours_m: 0, days_m: 1, good_score: 50, bad_score: 50, vote_percentage: 0, vote_minutes: nil, vote_good_score: 50, t_percentage: 's', t_minutes: 's', t_good_score: 's', t_vote_percentage: 's', t_vote_minutes: 'f', t_vote_good_score: 's', public: true, seq: 1)
      BestQuorum.create(name: '3 giorni', percentage: nil, minutes_m: 0, hours_m: 0, days_m: 3, good_score: 50, bad_score: 50, vote_percentage: 0, vote_minutes: nil, vote_good_score: 50, t_percentage: 's', t_minutes: 's', t_good_score: 's', t_vote_percentage: 's', t_vote_minutes: 'f', t_vote_good_score: 's', public: true, seq: 2)
      BestQuorum.create(name: '7 giorni', percentage: nil, minutes_m: 0, hours_m: 0, days_m: 7, good_score: 50, bad_score: 50, vote_percentage: 0, vote_minutes: nil, vote_good_score: 50, t_percentage: 's', t_minutes: 's', t_good_score: 's', t_vote_percentage: 's', t_vote_minutes: 'f', t_vote_good_score: 's', public: true, seq: 3)
      BestQuorum.create(name: '15 giorni', percentage: nil, minutes_m: 0, hours_m: 0, days_m: 15, good_score: 50, bad_score: 50, vote_percentage: 0, vote_minutes: nil, vote_good_score: 50, t_percentage: 's', t_minutes: 's', t_good_score: 's', t_vote_percentage: 's', t_vote_minutes: 'f', t_vote_good_score: 's', public: true, seq: 4)
      BestQuorum.create(name: '30 giorni', percentage: nil, minutes_m: 0, hours_m: 0, days_m: 30, good_score: 50, bad_score: 50, vote_percentage: 0, vote_minutes: nil, vote_good_score: 50, t_percentage: 's', t_minutes: 's', t_good_score: 's', t_vote_percentage: 's', t_vote_minutes: 'f', t_vote_good_score: 's', public: true, seq: 5)
      GroupAction.all.each do |group_action|
        ActionAbilitation.create(group_action: group_action, participation_role: admin)
      end
      #ActiveRecord::Base.connection.execute('ALTER SEQUENCE participation_roles_id_seq RESTART WITH 3')
    end
    Configuration.find_by(name: 'recaptcha').update_column(:value, 0)
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end
end
