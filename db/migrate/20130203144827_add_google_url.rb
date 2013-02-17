class AddGoogleUrl < ActiveRecord::Migration
  def up
    add_column :users, :google_page_url, :string, :limit => 255
  end

  def down
    remove_column :users, :google_page_url
  end
end
