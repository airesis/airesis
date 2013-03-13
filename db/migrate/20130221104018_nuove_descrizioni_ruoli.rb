class NuoveDescrizioniRuoli < ActiveRecord::Migration
  def up
    GroupAction.find_by_name('STREAM_POST').update_attribute(:description, 'Pubblicare nella Home Page del gruppo')
    GroupAction.find_by_name('CREATE_EVENT').update_attribute(:description, 'Creare eventi e votazioni')
    GroupAction.find_by_name('PROPOSAL').update_attribute(:description, 'Sostenere proposte a nome del gruppo')
    GroupAction.find_by_name('REQUEST_ACCEPT').update_attribute(:description, 'Aggiungere partecipanti nel gruppo')
    GroupAction.find_by_name('SEND_CANDIDATES').update_attribute(:description, 'Candidare utenti alle elezioni')
    GroupAction.find_by_name('PROPOSAL_VIEW').update_attribute(:description, 'Visualizzare le proposte private')
    GroupAction.find_by_name('PROPOSAL_PARTECIPATION').update_attribute(:description, 'Contribuire alle proposte')
    GroupAction.find_by_name('PROPOSAL_INSERT').update_attribute(:description, 'Inserire nuove proposte nel gruppo')

  end

  def down
  end
end
