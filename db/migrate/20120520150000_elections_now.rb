class ElectionsNow < ActiveRecord::Migration
  def up
    create_table :elections do |t|
      t.string :name, null: false
      t.string :description, null: false
      t.integer :event_id, null: false
      t.timestamp :groups_end_time, null: false
      t.timestamp :candidates_end_time, null: false
      t.string :status, null: false, default: '1'
      
      t.timestamps
    end
    

    
    add_foreign_key(:elections, :events)
    
    create_table :group_elections do |t|      
      t.integer :group_id, null: false
      t.integer :election_id, null: false
      t.timestamps
    end   
   
    add_foreign_key(:group_elections,:elections)
    add_foreign_key(:group_elections,:groups)
    
    add_index :group_elections, [:group_id,:election_id], unique: true
    
    create_table :candidates do |t|      
      t.integer :user_id, null: false
      t.integer :election_id, null: false
      t.timestamps
    end
    
    add_foreign_key(:candidates,:elections)
    add_foreign_key(:candidates,:users)
    
    add_index :candidates, [:user_id,:election_id], unique: true
    
    create_table :supporters do |t|      
      t.integer :candidate_id, null: false
      t.integer :group_id, null: false
      t.timestamps
    end
    
    add_foreign_key(:supporters,:candidates)
    add_foreign_key(:supporters,:groups)
    add_index :supporters, [:candidate_id,:group_id], unique: true
    
  end

  def down
    drop_table :supporters
    drop_table :candidates
    drop_table :group_elections
    drop_table :elections
  end
end
