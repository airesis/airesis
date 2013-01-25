class CreateBlockedEmails < ActiveRecord::Migration
  def change
    create_table :blocked_emails do |t|
      t.integer :notification_type_id
      t.integer :user_id

      t.timestamps
    end
  end
end
