class ItsTimeForQuorums < ActiveRecord::Migration
  def up
     #elenco dei quorum
     create_table :quorums do |t|
        t.string :name, :null => false, :limit => 100           #nome dell'opzione
        t.string :description, :null => true, :limit => 4000   #descrizione della modalità
        t.integer :percentage, :null => true                    #percentuale minima di utenti
        t.integer :valutations, :null => true                   #numero minimo di utenti
        t.integer :minutes, :null => true                       #durata minima
        t.string :condition, :limit => 5, :null => true         #'AND' o 'OR'
        t.integer :bad_score, :null => false                    #percentuale di scarto
        t.integer :good_score, :null => false                   #percentuale di approvazione
        t.boolean :active, :default => true, :null => false     #disaativata?
        t.boolean :public, :default => false, :null => false
        t.timestamps   
     end
     
     #crea i quorum di default
     fast = Quorum.create(:name => "fast", :percentage => 20, :minutes => 2880, :condition => 'OR', :good_score => 50, :bad_score => 50, :public => true)
     proceeding = Quorum.create(:name => "standard", :percentage => 30, :minutes => 21600, :condition => 'OR', :good_score => 60, :bad_score => 60, :public => true)
     long = Quorum.create(:name => "long", :percentage => 50, :minutes => 86400, :condition => 'AND',:good_score => 60, :bad_score => 60, :public => true)
     good_score = Quorum.create(:name => "good_score", :percentage => 30, :minutes => 21600, :condition => 'OR',:good_score => 30, :bad_score => 70, :public => true)
     
     #quorum a disposizione del gruppo
     create_table :group_quorums do |t|
       t.integer :quorum_id, :null => false
       t.integer :group_id, :null => true
     end
     
     add_foreign_key(:group_quorums,:quorums)
     add_foreign_key(:group_quorums,:groups)
     add_index :group_quorums, [:quorum_id,:group_id], :unique => true
     add_index :group_quorums, :quorum_id, :unique => true
     
     #diamo i quorum di default a tutti i vecchi gruppi
     Group.all.each do |group|
       Quorum.public.each do |quorum|
         copy = quorum.dup
         copy.public = false
         copy.save!
         GroupQuorum.create(:quorum_id => copy.id, :group_id => group.id)         
       end        
     end
    
     #ricreo il vecchio quorum
     old = Quorum.create(:name => "old", :valutations => 25, :good_score => 70, :bad_score => 30, :public => false)
              
     #campi aggiuntivi alla proposta
     add_column :proposals, :quorum_id, :integer
     add_column :proposals, :anonima, :boolean, :default => true, :null => false
     
     #assegno a tutte le proposte il loro vecchio quorum
     Proposal.all.each do |proposal|
       copy = old.dup
       copy.save!
       proposal.update_attribute(:quorum_id,copy.id)
     end
     
     #ora la colonna è not null
     change_column :proposals, :quorum_id, :integer, :null => false
     add_index :proposals, :quorum_id, :unique => true
     
     add_foreign_key(:proposals,:quorums)

     #campi aggiuntivi nei gruppi
     add_column :groups, :change_advanced_options, :boolean, :default => true, :null => false
     add_column :groups, :default_anonima, :boolean, :default => true, :null => false
  end

  def down
    remove_column :groups, :default_anonima
    remove_column :groups, :change_advanced_options
    
    remove_colum :proposals, :quorum_id
    remove_colum :proposals, :anonima
    
    drop_table :group_quorums
    drop_table :quorums
  end
end
