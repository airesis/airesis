class NewProposalTypes < ActiveRecord::Migration
  def up
    add_column :proposal_types, :seq, :integer, default: 0
    add_column :proposal_types, :active, :boolean, default: false
    ProposalType.create(short_name: 'RULE_BOOK', description: 'Regolamento', seq: 2, active: true)
    ProposalType.create(short_name: 'PRESS', description: 'Comunicato stampa', seq: 3, active: true)
    ProposalType.create(short_name: 'EVENT', description: 'Organizzazione evento', seq: 4, active: true)
    ProposalType.create(short_name: 'ESTIMATE', description: 'Preventivo di spesa', seq: 5, active: true)
    ProposalType.create(short_name: 'AGENDA', description: 'Ordine del giorno', seq: 6, active: true)
    ProposalType.create(short_name: 'CANDIDATES', description: 'Scelta di un candidato', seq: 7)
    ProposalType.find_by_short_name('STANDARD').update_attributes(seq: 1, active: true)
    ProposalType.find_by_short_name('POLL').update_attribute(:seq, 8)

  end

  def down
  end
end
