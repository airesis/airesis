class AddProposalsGroupActions < ActiveRecord::Migration
  def up
    GroupAction.create(id: 6, name: 'PROPOSAL_VIEW', description: 'Visualizzare le proposte interne al gruppo che vengono discusse')
    GroupAction.create(id: 7, name: 'PROPOSAL_PARTICIPATION', description: 'Partecipare alle proposte interne al gruppo votando e valutando')
    GroupAction.create(id: 8, name: 'PROPOSAL_INSERT', description: 'Inserire nuove proposte interne al gruppo a cui si appartiene')
  end

  def down
  end
end
