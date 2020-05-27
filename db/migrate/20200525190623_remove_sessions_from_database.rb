class RemoveSessionsFromDatabase < ActiveRecord::Migration[6.0]
  def change
    drop_table :sessions
  end
end
