class SondaggiosTables < ActiveRecord::Migration
  def up
    create_table :proposal_types do |t|
      t.string :short_name, null: false, limit: 10
      t.string :description, null: false, limit: 255
    end

    ProposalType.create(short_name: 'STANDARD', description: 'Proposta standard') { |c| c.id = 1 }.save
    ProposalType.create(short_name: 'POLL', description: 'Sondaggio') { |c| c.id = 2 }.save

    add_column :proposals, :proposal_type_id, :integer, null: false, default: 1

    create_table :proposal_schulze_votes do |t|
      t.integer :proposal_id, null: false
      t.string :preferences, null: false, limit: 255
      t.integer :count, null: false, default: 1
      t.timestamps
    end

    create_table :proposal_votation_types do |t|
      t.string :short_name, null: false, limit: 10
      t.string :description, null: false, limit: 255
    end

    ProposalVotationType.create(short_name: 'STANDARD', description: 'Standard') { |c| c.id = 1 }.save
    ProposalVotationType.create(short_name: 'PREFERENCE', description: 'Preference') { |c| c.id = 2 }.save
    ProposalVotationType.create(short_name: 'SCHULZE', description: 'Schulze') { |c| c.id = 3 }.save

    add_column :proposals, :proposal_votation_type_id, :integer, null: false, default: 1

    add_foreign_key :proposals, :proposal_types
    add_foreign_key :proposals, :proposal_votation_types
    add_foreign_key :proposal_schulze_votes, :proposals

    change_column :proposals, :quorum_id, :integer, null: true
  end

  def down
    change_column :proposals, :quorum_id, :integer, null: false
    remove_column :proposals, :proposal_votation_type_id
    remove_column :proposals, :proposal_type_id
    drop_table :proposal_votation_types
    drop_table :proposal_schulze_votes
    drop_table :proposal_types


  end
end
