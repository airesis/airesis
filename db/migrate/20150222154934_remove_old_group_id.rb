class RemoveOldGroupId < ActiveRecord::Migration
  def change
    remove_column :group_invitation_emails, :group_id
  end
end
