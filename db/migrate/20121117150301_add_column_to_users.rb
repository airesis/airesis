class AddColumnToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook_page_url, :string, :limit => 255
    add_column :users, :linkedin_page_url, :string, :limit => 255
  end
end
