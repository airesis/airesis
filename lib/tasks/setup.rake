namespace :airesis do

    desc 'Setup Airesis Environment'
    task :setup => :environment do
      sh "rake db:setup"
      sh "mkdir -p private/elfinder"
    end
end