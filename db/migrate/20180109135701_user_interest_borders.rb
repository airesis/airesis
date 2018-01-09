class UserInterestBorders < ActiveRecord::Migration
  def change
    add_column :users, :derived_interest_borders_tokens, :string, array: true, default: []
  end
end
