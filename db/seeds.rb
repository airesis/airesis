#encoding: utf-8
env_seed_file = File.join(Rails.root, 'db', 'environments', "#{Rails.env}.rb")
load(env_seed_file) if File.exist?(env_seed_file)