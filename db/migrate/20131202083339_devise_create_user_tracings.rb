class DeviseCreateUserTracings < ActiveRecord::Migration
  def self.up
    create_table :user_tracings do |t|
      t.integer  :user_id
      t.datetime :sign_in_at
      t.datetime :sign_out_at
      t.string :ip
      t.text :user_agent 
    end

    add_index :user_tracings, :user_id
  end

  def self.down
    drop_table :user_tracings
  end
end
