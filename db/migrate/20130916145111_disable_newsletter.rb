class DisableNewsletter < ActiveRecord::Migration
  def up
    rename_column :users, :email_alerts, :receive_newsletter
    User.where(:receive_newsletter => false).all.each do |user|
      NotificationType.all.each do |type|
      user.blocked_emails.create(:notification_type_id => type.id)
      end
    end
  end

  def down
    rename_column :users, :receive_newsletter, :email_alerts
  end
end
