class CreateProposalResults < ActiveRecord::Migration
  def change
    create_table :proposal_votation_results do |t|
      t.references :proposal, unique: true, index: true
      t.hstore :data, null: false
    end
  end
end
