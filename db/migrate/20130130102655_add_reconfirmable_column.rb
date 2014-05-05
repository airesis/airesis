class AddReconfirmableColumn < ActiveRecord::Migration
  def up
    add_column :users, :unconfirmed_email, :string, limit: 100
  end

  def down
    remove_column :users, :unconfirmed_email
  end
end
