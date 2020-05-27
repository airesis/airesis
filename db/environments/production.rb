Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each { |seed| load seed }

puts "creating an admin user with the following credentials: #{ENV['ADMIN_EMAIL']}/#{ENV['ADMIN_PASSWORD']}"

admin = User.new(password: ENV['ADMIN_PASSWORD'],
                 password_confirmation: ENV['ADMIN_PASSWORD'],
                 email:  ENV['ADMIN_EMAIL'],
                 name: 'Administrator',
                 surname: 'Administrator',
                 user_type_id: :administrator)
admin.skip_confirmation!
admin.save!
