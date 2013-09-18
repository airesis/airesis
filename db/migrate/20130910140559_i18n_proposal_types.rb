class I18nProposalTypes < ActiveRecord::Migration
  def up
    rename_column :proposal_types, :short_name, :name
    remove_column :proposal_types, :description

  end

  def down
    add_column :proposal_types, :description, :string
    rename_column :proposal_types, :name, :short_name
  end
end
