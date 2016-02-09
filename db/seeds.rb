puts "Starting DB seeding. This might take a while!"
env_seed_file = File.join(Rails.root, 'db', 'environments', "#{Rails.env}.rb")
load(env_seed_file) if File.exist?(env_seed_file)
puts 'seeding completed.'
