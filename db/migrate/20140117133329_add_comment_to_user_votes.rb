class AddCommentToUserVotes < ActiveRecord::Migration
  def up
    add_column :user_votes, :comment, :text
  end

  def down
    remove_column :user_votes, :comment
  end
end
