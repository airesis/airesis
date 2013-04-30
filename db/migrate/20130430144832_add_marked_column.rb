class AddMarkedColumn < ActiveRecord::Migration
  def up
    add_column :proposal_comments, :noise, :boolean, default: false
  end

  def down
    remove_column :proposal_comments, :noise
  end
end
