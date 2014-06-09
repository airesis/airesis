class RemoveFromProposals < ActiveRecord::Migration
  def change
    remove_column :proposals, :url, :string, null: false, default: ''
    remove_column :proposals, :subtitle, :string
    remove_column :proposals, :problem, :string
    remove_column :proposals, :problems, :string
    remove_column :proposals, :objectives, :string
  end
end
