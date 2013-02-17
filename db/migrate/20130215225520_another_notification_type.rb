class AnotherNotificationType < ActiveRecord::Migration
  def up
    NotificationType.create( :description => "Nuovi redattori per le proposte.", :notification_category_id => 1 ){ |c| c.id = 24 }.save
  end

  def down
    NotificationType.find(24).destroy
  end
end
