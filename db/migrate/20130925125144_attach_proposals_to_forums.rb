class AttachProposalsToForums < ActiveRecord::Migration
  def up
    create_table :frm_topic_proposals do |t|
      t.timestamps
      t.integer :topic_id
      t.integer :proposal_id
      t.integer :user_id
    end
  end

  def down
    drop_table :frm_topic_proposals
  end
end
