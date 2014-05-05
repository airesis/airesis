class AuditContributes < ActiveRecord::Migration
  def up
    create_table :proposal_comment_versions do |t|
      t.string   :item_type, null: false
      t.integer  :item_id,   null: false
      t.string   :event,     null: false
      t.string   :whodunnit
      t.text     :object
      t.datetime :created_at
    end
    add_index :proposal_comment_versions, [:item_type, :item_id]
  end

  def down
    drop_table :proposal_comment_versions
  end
end
