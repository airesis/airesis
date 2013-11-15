class LastColumnForProposals < ActiveRecord::Migration
  def up
    add_column :proposals, :vote_event_id, :integer, null: true
    add_foreign_key :proposals, :events, column: :vote_event_id
  end

  def down
    remove_column :proposals, :vote_event_id
  end
end
