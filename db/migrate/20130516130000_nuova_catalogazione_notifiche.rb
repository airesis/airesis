class NuovaCatalogazioneNotifiche < ActiveRecord::Migration
  def up
    add_column :notification_categories, :seq, :integer
    add_column :notification_categories, :short, :string, limit: 8
    a = NotificationCategory.create(description: 'Proposte che redigo', seq: 1, short: 'MYPROP')
    b = NotificationCategory.create(description: 'Proposte a cui partecipo', seq: 2, short: 'PROP')
    c = NotificationCategory.create(description: 'Nuove proposte', seq: 3, short: 'NEWPROP')
    d = NotificationCategory.create(description: 'Nuovi eventi', seq: 4, short: 'NEWEVENT')
    e = NotificationCategory.create(description: 'Gruppi', seq: 5, short: 'GROUPS')


    #Notification.where(notification_type_id: 8).destroy_all

    BlockedAlert.where(notification_type_id: 7).destroy_all
    BlockedEmail.where(notification_type_id: 7).destroy_all
    #BlockedAlert.where(notification_type_id: 8).destroy_all
    #BlockedEmail.where(notification_type_id: 8).destroy_all
    #BlockedAlert.where(notification_type_id: 15).destroy_all
    #BlockedEmail.where(notification_type_id: 15).destroy_all
    BlockedAlert.where(notification_type_id: 16).destroy_all
    BlockedEmail.where(notification_type_id: 16).destroy_all
    BlockedAlert.where(notification_type_id: 17).destroy_all
    BlockedEmail.where(notification_type_id: 17).destroy_all
    BlockedAlert.where(notification_type_id: 18).destroy_all
    BlockedEmail.where(notification_type_id: 18).destroy_all
    BlockedAlert.where(notification_type_id: 19).destroy_all
    BlockedEmail.where(notification_type_id: 19).destroy_all
    NotificationType.find(7).destroy
    #NotificationType.find(8).destroy
    #NotificationType.find(15).destroy
    NotificationType.find(16).destroy
    NotificationType.find(17).destroy
    NotificationType.find(18).destroy
    NotificationType.find(19).destroy


    NotificationType.find(5).update_attribute(:notification_category_id, a.id)
    NotificationType.find(6).update_attribute(:notification_category_id, a.id)
    NotificationType.find(20).update_attribute(:notification_category_id, a.id)
    NotificationType.find(22).update_attribute(:notification_category_id, a.id)
    NotificationType.find(23).update_attribute(:notification_category_id, a.id)

    NotificationType.find(1).update_attribute(:notification_category_id, b.id)
    NotificationType.find(2).update_attribute(:notification_category_id, b.id)
    NotificationType.find(4).update_attribute(:notification_category_id, b.id)
    NotificationType.find(21).update_attribute(:notification_category_id, b.id)
    NotificationType.find(24).update_attribute(:notification_category_id, b.id)

    NotificationType.find(3).update_attribute(:notification_category_id, c.id)
    NotificationType.find(10).update_attribute(:notification_category_id, c.id)

    NotificationType.find(13).update_attribute(:notification_category_id, d.id)
    NotificationType.find(14).update_attribute(:notification_category_id, d.id)

    NotificationType.find(9).update_attribute(:notification_category_id, e.id)
    NotificationType.find(12).update_attribute(:notification_category_id, e.id)
    NotificationType.find(8).update_attribute(:notification_category_id, e.id)
    NotificationType.find(15).update_attribute(:notification_category_id, e.id)

    NotificationCategory.where(short: nil).destroy_all
  end

  def down
  end
end
