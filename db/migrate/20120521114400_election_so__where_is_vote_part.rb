class ElectionSo_whereIsVotePart < ActiveRecord::Migration
  def up
      create_table :election_votes do |t|
        t.integer :user_id, :null => false
        t.integer :election_id, :null => false
        t.timestamps
      end
      
      add_foreign_key(:election_votes,:users)
      add_foreign_key(:election_votes,:elections)
      
      add_index :election_votes, [:user_id,:election_id], :unique => true
      
      create_table :simple_votes do |t|
        t.integer :candidate_id, :null => false
        t.integer :count, :null => false, :default => 0
        t.timestamps
      end
      
      add_foreign_key(:simple_votes,:candidates)
      add_index :simple_votes, :candidate_id, :unique => true
      
      create_table :schulze_votes do |t|
        t.integer :election_id, :null => false
        t.string :preferences, :null => false
        t.integer :count, :null => false, :default => 0
        t.timestamps
      end
      
      add_foreign_key(:schulze_votes,:elections)
      add_index :schulze_votes, [:election_id,:preferences], :unique => true
      
  end

  def down
    drop table :election_votes
    drop table :simple_votes
    drop table :schulze_votes
  end
end
