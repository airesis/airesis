class CreateSearchParticipants < ActiveRecord::Migration
  def change
    create_table :search_participants do |t|
      t.integer :role_id
      t.integer :status_id
      t.string :keywords
      t.integer :group_id
      t.timestamps
    end
  end
end
