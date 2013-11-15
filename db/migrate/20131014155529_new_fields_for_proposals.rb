class NewFieldsForProposals < ActiveRecord::Migration
  #add two columns for informations about vote period
  def up
    add_column :proposals, :vote_defined, :boolean, default: false
    add_column :proposals, :vote_starts_at, :timestamp
    add_column :proposals, :vote_ends_at, :timestamp
  end

  def down
    remove_column :proposals, :vote_starts_at
    remove_column :proposals, :vote_ends_at
    remove_column :proposals, :vote_defined
  end
end
