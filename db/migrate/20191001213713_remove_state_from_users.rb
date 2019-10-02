class RemoveStateFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :state, :text
  end
end
