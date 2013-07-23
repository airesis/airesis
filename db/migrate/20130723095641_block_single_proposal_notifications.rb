class BlockSingleProposalNotifications < ActiveRecord::Migration
  def up
    create_table :blocked_proposal_alerts do |t|
      t.timestamps
      t.integer :proposal_id
      t.integer :user_id
      t.boolean :updates, default: false #alerts about text change
      t.boolean :contributes, default: false #alerts about new contributes
      t.boolean :state, default: false #alerts about state change
      t.boolean :authors, default: false #alerts about new authors
      t.boolean :valutations, default: false #alerts about new valutations
    end


    add_foreign_key :blocked_proposal_alerts, :proposals
    add_foreign_key :blocked_proposal_alerts, :users
  end

  def down
    drop_table :blocked_proposal_alerts
  end
end
