class AddAttachmentFileToDocuments < ActiveRecord::Migration
  def self.up
    add_column :groups, :max_storage_size, :integer, :default => 51200, :null => false
    add_column :groups, :actual_storage_size, :integer, :default => 0, :null => false
  end

  def self.down
    remove_column :groups, :max_storage_size
    remove_column :groups, :actual_storage_size
  end
end
