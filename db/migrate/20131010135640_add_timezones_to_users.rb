class AddTimezonesToUsers < ActiveRecord::Migration
  def up
    User.all.each do |user|
      user.geocode
    end
  end

  def down
    User.update_all(:time_zone,'Rome')
  end
end
