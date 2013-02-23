class RemoveSomeNotificationsDefault < ActiveRecord::Migration
  def up
    User.all.each do |user|

      user.blocked_alerts.where(:notification_type_id => 20).first_or_create!
      user.blocked_alerts.where(:notification_type_id => 21).first_or_create!
      user.blocked_alerts.where(:notification_type_id => 13).first_or_create!
      NotificationType.find(11).destroy
      NotificationType.find(13).update_attribute(:description, 'Nuovi eventi pubblici')
      NotificationType.find(14).update_attribute(:description, 'Nuovi eventi dei gruppi a cui partecipo')
    end
  end

  def down

  end
end
