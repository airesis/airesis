class DropSysDocumentType < ActiveRecord::Migration[5.2]
  def change
    drop_table :sys_document_types
  end
end
