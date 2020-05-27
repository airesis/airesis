RSpec.configure do |config|
  config.before(:all) do
    load Rails.root.join('db/seeds/data/database_functions.rb')
  end

  config.before do
    # TODO: these should not be needed.
    load Rails.root.join('db/seeds/data/notification_types.rb')
    load Rails.root.join('db/seeds/data/proposal_types.rb')
    load Rails.root.join('db/seeds/data/proposal_states.rb')
    load Rails.root.join('db/seeds/data/event_types.rb')
    load Rails.root.join('db/seeds/data/participation_roles.rb')
    load Rails.root.join('db/seeds/data/vote_types.rb')
    load Rails.root.join('db/seeds/data/quorums.rb')
    SysLocale.create!(key: 'en-EU', host: 'localhost', territory: create(:continent, :europe), default: true)
    Configuration.create(name: 'folksonomy', value: 1)
    Configuration.create!(name: 'recaptcha', value: 0)
    Configuration.create!(name: 'proposal_categories', value: 1)
    Configuration.create!(name: 'group_areas', value: 1)
    Configuration.create!(name: 'socialnetwork_active', value: 1)
    Configuration.create!(name: 'user_messages', value: 1)
  end

  config.before(:each, seeds: true) do
    load_database
  end

  # TODO: remove
  def load_municipalities
    create(:municipality, :bologna)
  end

  def load_database
    load_municipalities
    admin = ParticipationRole.create(GroupAction::LIST.index_with { |_a| true }.merge(name: ParticipationRole::ADMINISTRATOR, description: 'Amministratore'))
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
