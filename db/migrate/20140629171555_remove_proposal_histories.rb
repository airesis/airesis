class RemoveProposalHistories < ActiveRecord::Migration
  def change
    drop_table :proposal_histories do |t|
      t.integer :proposal_id, null: false
      t.integer :user_id, null: false #utente che effettua la modifica
      t.string :content, limit: 20000, null: false
      t.string :problem, limit: 20000
      t.integer :valutations, null: false
      t.integer :rank, null: false
      t.timestamps
    end
  end
end
