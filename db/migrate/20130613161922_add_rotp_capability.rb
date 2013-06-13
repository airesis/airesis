class AddRotpCapability < ActiveRecord::Migration
  def up
    add_column :users, :rotp_secret, :string, limit: 16
    add_column :users, :rotp_enabled, :boolean, default: false
    Configuration.create(name: 'rotp', value: 0)
  end

  def down
    remove_column :users, :rotp_secret
    remove_column :users, :rotp_enabled
    Configuration.find_by_name('rotp').destroy
  end
end
