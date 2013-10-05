class AaBitMoreSpaceForComments < ActiveRecord::Migration
  def up
    change_column :proposal_comments, :content, :string, limit: 2500
  end

  def down
    change_column :proposal_comments, :content, :string, limit: 2000
  end
end
