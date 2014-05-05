class NuoviTipiNotifiche < ActiveRecord::Migration
  def up
    add_column :user_alerts, :created_at, :datetime
    add_column :user_alerts, :updated_at, :datetime
    add_column :user_alerts, :checked_at, :datetime
   NotificationType.create(id: 20, description: 'Nuova valutazione ad una mia proposta.', notification_category_id: 1)
   NotificationType.create(id: 21, description: 'Nuova valutazione ad una proposta a cui partecipi.', notification_category_id: 1)
  end

  def down
    remove_column :user_alerts, :created_at, :datetime
    remove_column :user_alerts, :updated_at, :datetime
    remove_column :user_alerts, :checked_at, :datetime
  end
end
