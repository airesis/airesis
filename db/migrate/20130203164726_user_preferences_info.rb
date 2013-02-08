class UserPreferencesInfo < ActiveRecord::Migration
  def up
    add_column :users, :show_tooltips, :boolean, :default => true
    add_column :users, :show_urls, :boolean, :default => true
  end

  def down
    remove_column :users, :show_tooltips
    remove_column :users, :show_urls
  end
end
