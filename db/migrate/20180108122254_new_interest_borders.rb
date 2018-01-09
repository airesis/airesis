class NewInterestBorders < ActiveRecord::Migration
  def change
    add_column :proposals, :interest_borders_tokens, :string, array: true, default: []
    add_column :proposals, :derived_interest_borders_tokens, :string, array: true, default: []
  end
end
