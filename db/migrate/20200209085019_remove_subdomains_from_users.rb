class RemoveSubdomainsFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :subdomain, :string
  end
end
