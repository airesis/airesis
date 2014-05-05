class AddCountToNotifications < ActiveRecord::Migration
  def up
    # TODO undo keep it for convenience
    # Notification.all(conditions: ['notifications.notification_type_id = ?', NotificationType::NEW_CONTRIBUTES_MINE]).each do |notification|
    #  notification.notification_data.find_or_create_by_name('count').update_attribute(:value,1)
    #end

  end

  def down

  end
end
