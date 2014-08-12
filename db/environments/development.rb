Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each { |seed| load seed }

admin = User.new(password: ENV['ADMIN_PASSWORD'],
                 password_confirmation: ENV['ADMIN_PASSWORD'],
                 email:  ENV['ADMIN_EMAIL'],
                 name: 'Administrator',
                 surname: 'Administrator',
                 user_type_id: UserType::ADMINISTRATOR)
admin.skip_confirmation!
admin.save!
