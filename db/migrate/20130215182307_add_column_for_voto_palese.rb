class AddColumnForVotoPalese < ActiveRecord::Migration
  def up
    create_table :vote_types do |t|
      t.string :description, null: false, limit: 200
    end

    VoteType.create( description: "Positivo"){ |c| c.id = 1 }.save
    VoteType.create( description: "Neutro"){ |c| c.id = 2 }.save
    VoteType.create( description: "Negativo"){ |c| c.id = 3 }.save

    add_column :user_votes, :vote_type_id, :integer
    add_foreign_key(:user_votes,:vote_types)

    add_column :proposals, :secret_vote, :boolean, default: true, null: false
    add_column :groups, :default_secret_vote, :boolean, default: true, null: false
  end

  def down
    remove_column :user_votes, :vote_type_id
    drop_table :vote_types
    remove_column :proposals, :secret_vote
    remove_column :proposals, :default_secret_vote
  end
end
