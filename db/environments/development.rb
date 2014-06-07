env_seed_file = File.join(Rails.root, 'db', 'environments', "#{Rails.env}.rb")

Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each { |seed| load seed }