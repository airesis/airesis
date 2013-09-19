namespace :airesis do
  namespace :notifications do

    desc 'Clear all notifications in database'
    task :clear => :environment do
      Notification.destroy_all
    end
  end
end