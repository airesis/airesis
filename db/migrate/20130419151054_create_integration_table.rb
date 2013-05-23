class CreateIntegrationTable < ActiveRecord::Migration
  def up
    create_table :integrated_contributes do |t|
      t.integer :proposal_revision_id, null: false
      t.integer :proposal_comment_id, null: false
    end

    add_foreign_key :integrated_contributes, :proposal_revisions
    add_foreign_key :integrated_contributes, :proposal_comments
    add_index :integrated_contributes, [:proposal_revision_id,:proposal_comment_id], unique: true, name: 'unique_contributes'

    add_column :proposal_comments, :integrated, :boolean, null: false, default: false
  end

  def down
    remove_column :proposal_comments, :integrated
    drop_table :integrated_contributes
  end
end
