class RemoveCommentFromVotes < ActiveRecord::Migration[5.2]
  def change
    remove_column :user_votes, :comment, :text
  end
end
