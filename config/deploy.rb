# config valid only for Capistrano 3.1
lock '3.4.0'

set :repo_url, 'git@github.com:coorasse/airesis.git'

set :deploy_to, '~/airesis_capistrano'

set :rails_env, 'production'

set :linked_files, %w(config/application.yml config/database.yml config/private_pub.yml config/sidekiq.yml config/sunspot.yml .htaccess)

set :linked_dirs, %w(bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/assets solr private/elfinder public/ckeditor_assets)

set :rvm1_ruby_version, File.read('.ruby-version').strip

set :sidekiq_config, "#{current_path}/config/sidekiq.yml"

set :passenger_restart_with_touch, true

set :passenger_environment_variables, path: '$HOME/passenger-4.0.26/bin:$PATH'

set :default_env, rvm_bin_path: '~/.rvm/bin'

set :default_shell, 'bash -l'

set :bundle_flags, '--deployment'


namespace :app do
  task :update_rvm_key do
    on roles(:app) do
      execute :gpg, '--keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3'
    end
  end
end

before 'deploy', 'rvm1:install:ruby'
before 'deploy', 'rvm1:install:rvm'
before 'rvm1:install:rvm', 'app:update_rvm_key'
