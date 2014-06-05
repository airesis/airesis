class TimestampsForRequests < ActiveRecord::Migration
  def up
    add_column :group_participation_requests, :created_at, :datetime
    add_column :group_participation_requests, :updated_at, :datetime
  end

  def down
    remove_column :group_participation_requests, :created_at
    remove_column :group_participation_requests, :updated_at
  end
end
