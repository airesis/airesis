require 'open-uri'

class MigrateOldAvatars1 < ActiveRecord::Migration
  def change
    User.joins(:authentications).
      where(avatar_file_name: nil, authentications: {provider: 'facebook'}).readonly(false).find_each do |user|
      begin
        uid = user.authentications.find_by(provider: 'facebook').uid
        user.avatar = URI.parse("https://graph.facebook.com/#{uid}/picture?width=400&height=400")
        user.avatar.instance_write(:file_name, "#{SecureRandom.hex(16)}")
        user.save!
      rescue
        open('log/avatar_errors.log', 'a') { |f|
          f.puts "#{user.id}"
        }
      end
    end
  end
end
