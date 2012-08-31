class AddGroupProposals < ActiveRecord::Migration
  #creo una tabella che mi permetta di creare proposte di gruppo
  #quando una proposta viene creata internamente ad un gruppo
  #inserisco un record in questa tabella per collegare la proposta al gruppo
  #sulla proposte vi è un flag aggiuntivo, 'private', che viene impostato a true per le proposte 'interne'
  #quando sono interne, la visibilità è limitata ai partecipanti al gruppo
  #che l'ha indetta.
  #creo una tabella n-n perchè in futuro si potrebbero creare proposte "interne" condivise da più gruppi   
  def up
    create_table :group_proposals do |t|
      t.integer :proposal_id, :null => false
      t.integer :group_id, :null => false      
      t.timestamps
    end
    
    add_foreign_key(:group_proposals,:proposals)
    add_foreign_key(:group_proposals,:groups)
    add_index :group_proposals, [:proposal_id,:group_id], :unique => true
    
    add_column :proposals, :private, :boolean, :default => false, :null => false
  end

  def down
    drop_table :group_proposals
    drop_column :proposals, :private
  end
end
