class AddDocumentsActions < ActiveRecord::Migration
  def up
    GroupAction.create(:id => 9, :name => 'DOCUMENT_VIEW', :description => 'Visualizzare i documenti')
    GroupAction.create(:id => 10, :name => 'DOCUMENT_MANAGE', :description => 'Gestire i documenti')
  end

  def down
    GroupAction.find_by_name('DOCUMENT_VIEW').destroy
    GroupAction.find_by_name('DOCUMENT_MANAGE').destroy
  end
end
