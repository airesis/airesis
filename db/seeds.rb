#encoding: utf-8
puts "loading seeds"
env_seed_file = File.join(Rails.root, 'db', 'environments', "#{Rails.env}.rb")
load(env_seed_file) if File.exist?(env_seed_file)
