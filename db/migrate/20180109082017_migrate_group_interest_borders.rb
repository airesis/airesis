class MigrateGroupInterestBorders < ActiveRecord::Migration
  def change
    add_column :groups, :interest_border_token, :string
    add_column :groups, :derived_interest_borders_tokens, :string, array: true, default: []
  end
end
