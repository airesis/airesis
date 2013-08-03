class NewDefaultForGroups < ActiveRecord::Migration
  def up
    change_column :groups, :accept_requests, :string, null: false, default: 'p'
  end

  def down
  end
end
