class CreateGroupActions < ActiveRecord::Migration
  def up
    GroupAction.create(:id => 1, :name => 'STREAM_POST', :description => 'Inserire i post nello stream')
    GroupAction.create(:id => 2, :name => 'CREATE_EVENT', :description => 'Creare eventi')
    GroupAction.create(:id => 3, :name => 'PROPOSAL', :description => 'Sostenere proposte')
    GroupAction.create(:id => 4, :name => 'REQUEST_ACCEPT', :description => 'Accettare le richieste di partecipazione')
  end

  def down
  end
end
