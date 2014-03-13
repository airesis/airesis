class AddViewCountForProposal < ActiveRecord::Migration
  def up
    add_column :proposals, :views_count, :integer, null: false, default: 0
  end

  def down
    remove_column :proposals, :views_count
  end
end
