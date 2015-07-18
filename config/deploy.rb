# config valid only for Capistrano 3.1
lock '3.4.0'

set :repo_url, 'git@github.com:coorasse/airesis.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '~/airesis_capistrano'

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

files = %w{config/application.yml config/database.yml config/private_pub.yml config/sunspot.yml .htaccess}

set :linked_files, fetch(:linked_files, []).push(files)

folders = %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/assets solr private/elfinder public/ckeditor_assets }

set :linked_dirs, fetch(:linked_dirs, []).push(folders)

set :rvm1_ruby_version, File.read('.ruby-version').strip

set :sidekiq_config, "#{current_path}/config/sidekiq.yml"

set :passenger_restart_with_touch, true

set :passenger_environment_variables, {path: '$HOME/passenger-4.0.26/bin:$PATH'}

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
