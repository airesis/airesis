#genera una tabella per memorizzare i nickname assegnati agli utenti in una proposta
class ProposalNicknames < ActiveRecord::Migration
  def up
    create_table :proposal_nicknames do |t|
      t.integer :proposal_id, :null => false
      t.integer :user_id, :null => false
      t.string :nickname, :null => false      
      t.timestamps
    end
    
    add_foreign_key(:proposal_nicknames,:proposals)
    add_foreign_key(:proposal_nicknames,:users)
    add_index :proposal_nicknames, [:proposal_id,:user_id], :unique => true
    add_index :proposal_nicknames, [:proposal_id,:nickname], :unique => true
    add_index :proposal_nicknames, :nickname

  end

  def down
     drop_table :proposal_nicknames
  end
end
