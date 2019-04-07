RSpec.configure do |config|
  config.before(:suite) do
    Configuration.find_by(name: 'recaptcha').update_column(:value, 0)
  end

  config.before(:each, seeds: true) do
    load_database
  end

  def load_municipalities
    a1 = Continent.first
    s1 = Country.find_by(description: 'Italy')
    r14 = Region.create(description: 'Emilia Romagna', country_id: s1.id, continent_id: a1.id)
    p1 = Province.create(description: 'Bologna', region_id: r14.id, country_id: s1.id, continent_id: a1.id, sigla: 'BO')
    Municipality.create(description: 'Bologna', province_id: p1.id, region_id: r14.id, country_id: s1.id, continent_id: a1.id, population: 371_217)
  end

  def load_database
    load_municipalities
    admin = ParticipationRole.create(Hash[GroupAction::LIST.map { |a| [a, true] }].merge(name: ParticipationRole::ADMINISTRATOR, description: 'Amministratore'))
    return unless BestQuorum.count == 0
    base_attrs = { percentage: nil, minutes_m: 0, hours_m: 0, good_score: 50, bad_score: 50, vote_percentage: 0,
                   vote_minutes: nil, vote_good_score: 50, t_percentage: 's', t_minutes: 's', t_good_score: 's',
                   t_vote_percentage: 's', t_vote_minutes: 'f', t_vote_good_score: 's', public: true }
    BestQuorum.create([base_attrs.merge(name: '1 giorno', days_m: 1, seq: 1),
                       base_attrs.merge(name: '3 giorni', days_m: 3, seq: 2),
                       base_attrs.merge(name: '7 giorni', days_m: 7, seq: 3),
                       base_attrs.merge(name: '15 giorni', days_m: 15, seq: 4),
                       base_attrs.merge(name: '30 giorni', days_m: 30, seq: 5)])
  end
end
