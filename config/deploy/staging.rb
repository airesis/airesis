server_str = 'ssh.alwaysdata.com'
user_str = 'airesistest'

set :application, 'airesis-staging'
role :app, "#{user_str}@#{server_str}"
role :web, "#{user_str}@#{server_str}"
role :db,  "#{user_str}@#{server_str}"

server server_str, user: user_str, roles: %w(web app)

set :branch, 'develop'

set :deploy_to, '/home/airesistest/airesis_capistrano'
