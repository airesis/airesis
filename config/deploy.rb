# config valid only for Capistrano 3.1
lock '3.4.0'

set :repo_url, 'git@github.com:coorasse/airesis.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '~/airesis_capistrano'

set :rails_env, 'production'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w(bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/assets solr private/elfinder public/ckeditor_assets)

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :rvm1_ruby_version, File.read('.ruby-version').strip

set :linked_files, %w(config/application.yml config/database.yml config/private_pub.yml config/sunspot.yml .htaccess)

set :sidekiq_config, "#{current_path}/config/sidekiq.yml"

set :passenger_restart_with_touch, true

set :passenger_environment_variables, path: '$HOME/passenger-4.0.26/bin:$PATH'

set :default_env, rvm_bin_path: '~/.rvm/bin'

set :default_shell, 'bash -l'

set :bundle_flags, '--deployment'

set :deploy_to, '/home/coorasse/airesis_capistrano'

before 'deploy', 'rvm1:install:ruby'
after 'deploy:restart', 'deploy:cleanup'
