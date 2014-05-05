class CountProposalAlerts < ActiveRecord::Migration
  def up
    create_table :proposal_alerts do |t|
      t.integer :proposal_id, null: false
      t.integer :user_id, null: false
      t.integer :count, null: false, default: 0
    end
    UserAlert.joins(notification: :notification_data).where(checked: false).where("notification_data.name = 'proposal_id'").all.each do |alert|
      @pa = ProposalAlert.find_or_create_by_proposal_id_and_user_id(alert.notification.data[:proposal_id].to_i, alert.user_id)
      @pa.increment!(:count)
    end

  end

  def down
    drop_table :proposal_alerts
  end
end
