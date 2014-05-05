class AddDocumentsActions < ActiveRecord::Migration
  def up
    GroupAction.create(name: 'DOCUMENT_VIEW', description: 'Visualizzare i documenti'){ |c| c.id = 9 }.save
    GroupAction.create(name: 'DOCUMENT_MANAGE', description: 'Gestire i documenti'){ |c| c.id = 10 }.save
  end

  def down
    GroupAction.find_by_name('DOCUMENT_VIEW').destroy
    GroupAction.find_by_name('DOCUMENT_MANAGE').destroy
  end
end
