class RemoveCertifications < ActiveRecord::Migration[5.2]
  def change
    remove_column :groups, :certified, :boolean
    remove_column :groups, :subdomain, :string
    drop_table(:user_sensitives) {}
  end
end
