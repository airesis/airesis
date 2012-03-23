class BetterProposals < ActiveRecord::Migration
  def up
    add_column :proposals, :problem, :string, :limit => 20000
    add_column :users, :banned, :boolean, :null => false, :default => false
    #genera la tabella per memorizzare la history della proposta
    create_table :proposal_histories do |h|
      h.integer :proposal_id, :null => false
      h.integer :user_id, :null => false #utente che effettua la modifica
      #t.integer :index
      h.string :content, :limit => 20000, :null => false
      h.string :problem, :limit => 20000
      h.integer :valutations, :null => false
      h.integer :rank, :null => false
      h.timestamps
    end
  end

  def down
    drop_table :proposal_histories
    remove_column :proposals, :problem
    remove_column :users, :banned
  end
end
