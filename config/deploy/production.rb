server_str = 'ssh.alwaysdata.com'
user_str = 'coorasse'

set :application, 'airesis-production'
role :app, "#{user_str}@#{server_str}"
role :web, "#{user_str}@#{server_str}"
role :db,  "#{user_str}@#{server_str}"

server server_str, user: user_str, roles: %w(web app)

set :branch, 'master'

set :deploy_to, '/home/coorasse/airesis_capistrano'
