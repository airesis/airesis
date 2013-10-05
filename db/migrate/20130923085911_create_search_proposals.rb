class CreateSearchProposals < ActiveRecord::Migration
  def up
    create_table :search_proposals do |t|
      t.timestamps
      t.integer :user_id #belongs to user
      t.integer :group_id #or belongs to group
      t.integer :proposal_category_id
      t.integer :group_area_id
      t.integer :proposal_type_id
      t.integer :proposal_state_id
      t.integer :tag_id
      t.integer :interest_border_id
      t.datetime :created_at_from
      t.datetime :created_at_to
    end
  end


  def down
    drop_table :search_proposals
  end
end
