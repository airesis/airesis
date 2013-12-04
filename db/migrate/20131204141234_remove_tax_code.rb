class RemoveTaxCode < ActiveRecord::Migration
  def up
    add_column :user_sensitives, :channel, :string
    add_column :groups, :disable_partecipation_requests, :boolean, :default => false
    add_column :groups, :disable_forums, :boolean, :default => false
  end

  def down
    remove_column :groups, :disable_forums
    remove_column :groups, :disable_partecipation_requests
    remove_column :user_sensitives, :channel
  end
end
