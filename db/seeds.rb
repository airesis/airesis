puts "DB seeding. This will take around two minutes..."
env_seed_file = File.join(Rails.root, 'db', 'environments', "#{Rails.env}.rb")
load(env_seed_file) if File.exist?(env_seed_file)
puts '...seeding completed successfully!'
