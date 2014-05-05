class Groupsdisabledocuments < ActiveRecord::Migration
  def up
    add_column :groups, :disable_documents, :boolean, default: false
  end

  def down
    remove_column :groups, :disable_documents
  end
end
