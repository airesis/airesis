class DropUserTypes < ActiveRecord::Migration[6.0]
  def change
    remove_foreign_key :users, :user_types
    drop_table :user_types
  end
end
