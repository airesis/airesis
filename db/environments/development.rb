Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].sort.each { |seed|
  startTime = Time.now
  puts 'Seeding ' + File.basename(seed)
  load seed
  endTime = Time.now
  delta = endTime - startTime
  puts 'Completed ' + File.basename(seed) + ' in ' + delta.abs.to_s  + 's'
}

puts "creating an admin user with the following credentials: #{ENV['ADMIN_EMAIL']}/#{ENV['ADMIN_PASSWORD']}"

admin = User.new(password: ENV['ADMIN_PASSWORD'],
                 password_confirmation: ENV['ADMIN_PASSWORD'],
                 email:  ENV['ADMIN_EMAIL'],
                 name: 'Administrator',
                 surname: 'Administrator',
                 user_type_id: UserType::ADMINISTRATOR)
admin.skip_confirmation!
admin.save!
