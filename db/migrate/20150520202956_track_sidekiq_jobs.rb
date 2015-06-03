class TrackSidekiqJobs < ActiveRecord::Migration
  def change
    create_table :alert_jobs do |t|
      t.references :trackable, null: false, polymorphic: true
      t.references :notification_type, null: false
      t.references :user, null: false
      t.references :alert
      t.string :jid, null: false
      t.integer :accumulated_count, null: false, default: 1
      t.integer :status, null: false, default: 0
      t.timestamps null: false
    end

    add_reference :alerts, :trackable, polymorphic: true

    create_table :email_jobs do |t|
      t.references :alert, null: false
      t.string :jid, null: false
      t.integer :status, null: false, default: 0
      t.timestamps null: false
    end

    add_column :notification_types, :email_delay, :integer
    add_column :notification_types, :alert_delay, :integer

    NotificationType.update_all(email_delay: 2, alert_delay: 1) unless reverting?

    change_column_null :notification_types, :email_delay, false
    change_column_null :notification_types, :alert_delay, false

    add_column :notification_types, :cumulable, :boolean, default: false, null: false

    NotificationType.find_by(name: 'text_update').update(cumulable: true) unless reverting?
  end
end
