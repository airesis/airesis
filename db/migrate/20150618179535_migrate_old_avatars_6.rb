require 'open-uri'

class MigrateOldAvatars6 < ActiveRecord::Migration
  def change
    User.joins(:authentications).
      where(avatar_file_name: nil, authentications: {provider: 'google_oauth2'}).
      readonly(false).find_each do |user|
      begin
        uid = user.authentications.find_by(provider: 'google_oauth2').uid
        url = "https://www.googleapis.com/plus/v1/people/#{uid}?fields=image&key=#{ENV['MAPS_API_KEY']}"
        json = JSON.parse(open(url).read)
        image_url = json['image']['url']
        user.avatar = URI.parse("#{image_url}&sz=400")
        user.avatar.instance_write(:file_name, "#{SecureRandom.hex(16)}")
        user.save!
      rescue
        open('log/avatar_errors_2.log', 'a') { |f|
          f.puts "#{user.id}"
        }
      end
    end
  end
end
