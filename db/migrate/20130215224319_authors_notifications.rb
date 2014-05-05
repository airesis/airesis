class AuthorsNotifications < ActiveRecord::Migration
  def up
    NotificationType.create( description: "Utente disponibile a redigere la sintesi di una proposta.", notification_category_id: 1 ){ |c| c.id = 22 }.save
    NotificationType.create( description: "Accettazione come redattore di una proposta.", notification_category_id: 1 ){ |c| c.id = 23 }.save
  end

  def down
  end
end
