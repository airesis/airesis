class FacebookColumns < ActiveRecord::Migration
  def self.up
     create_table :authentications do |t|
      t.integer :user_id
      t.string :provider
      t.string :token      
      t.string :uid
    end
  end

  def self.down
     drop_table :authentications
  end
end
