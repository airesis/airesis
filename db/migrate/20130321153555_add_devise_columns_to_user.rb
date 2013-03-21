class AddDeviseColumnsToUser < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.token_authenticatable
    end
  end

  def down
    t.remove :authentication_token
  end
end
