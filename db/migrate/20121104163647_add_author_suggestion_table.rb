class AddAuthorSuggestionTable < ActiveRecord::Migration
  def up
     create_table :available_authors do |t|
      t.integer :proposal_id, null: false
      t.integer :user_id, null: false
      t.timestamps
    end
    
    add_foreign_key(:available_authors,:proposals)
    add_foreign_key(:available_authors,:users)
    add_index :available_authors, [:proposal_id,:user_id], unique: true
  end

  def down
    drop_table :available_authors
  end
end
