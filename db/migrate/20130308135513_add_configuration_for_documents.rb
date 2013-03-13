class AddConfigurationForDocuments < ActiveRecord::Migration
  def up
    Configuration.create(name: 'documents_active', value: 1)
  end

  def down
    Configuration.find_by_name('documents_active').destroy
  end
end
