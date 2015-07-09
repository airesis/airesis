class RemoveOldGlobalizeColumns < ActiveRecord::Migration
  def change
    remove_column :continents, :description, :string, limit: 255, null: false
    remove_column :countries, :description, :string, limit: 255, null: false
  end
end
