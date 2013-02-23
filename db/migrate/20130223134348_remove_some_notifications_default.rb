class RemoveSomeNotificationsDefault < ActiveRecord::Migration
  def up
    User.all.each do |user|
      user.blocked_alerts.where(:notification_type_id => 20).first_or_create!
      user.blocked_alerts.where(:notification_type_id => 21).first_or_create!
      user.blocked_alerts.where(:notification_type_id => 13).first_or_create!
      user.blocked_alerts.where(:notification_type_id => 3).first_or_create!
    end
    NotificationType.find(11).destroy
    NotificationType.find(13).update_attribute(:description, 'Nuovi eventi pubblici')
    NotificationType.find(14).update_attribute(:description, 'Nuovi eventi dei gruppi a cui partecipo')
    NotificationType.find(1).update_attribute(:description, 'Nuovi contributi e suggerimenti alle proposte a cui partecipo')
    NotificationType.find(2).update_attribute(:description, 'Aggiornamento del testo di una proposta a cui partecipo')
    NotificationType.find(3).update_attribute(:description, 'Nuove proposte inserite nello spazio comune')
    NotificationType.find(4).update_attribute(:description, 'Cambio di stato di una proposta a cui partecipo')
    NotificationType.find(10).update_attribute(:description, 'Nuove proposte interne al gruppo')
    NotificationType.find(20).update_attribute(:description, 'Nuova valutazione ad una mia proposta')
    NotificationType.find(21).update_attribute(:description, 'Nuova valutazione ad una proposta a cui partecipo')
    NotificationType.find(22).update_attribute(:description, 'Utente disponibile a redigere la sintesi di una proposta')
    NotificationType.find(23).update_attribute(:description, 'Accettazione come redattore di una proposta')
    NotificationType.find(24).update_attribute(:description, 'Nuovi redattori per le proposte')
  end

  def down
    NotificationType.create( :description => "Cambio di stato di una proposta di gruppo.", :notification_category_id => 3 ){ |c| c.id = 11 }.save
  end
end
