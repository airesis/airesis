class AddOldAuthorsTable < ActiveRecord::Migration
  def up
    #added to keep the qorumfrom which it has been created
    add_column :quorums, :quorum_id, :integer, null: true
    add_foreign_key :quorums, :quorums

    #this table keep the history of the proposal after it has been abandoned
    create_table :proposal_lives do |t|
      t.timestamps
      t.integer :proposal_id
      t.integer :quorum_id #old quorum
      t.integer :valutations
      t.integer :rank
      t.integer :seq
    end

    add_foreign_key :proposal_lives, :proposals
    add_foreign_key :proposal_lives, :quorums

    #old authors of that proposal
    create_table :old_proposal_presentations do |t|
      t.timestamps
      t.integer :proposal_life_id
      t.integer :user_id
    end

    add_foreign_key :old_proposal_presentations, :users
    add_foreign_key :old_proposal_presentations, :proposal_lives


    Proposal.where(proposal_state_id: ProposalState::ABANDONED).each do |proposal|
      #save the old quorum, valutations and rank
      life = proposal.proposal_lives.create(quorum_id: proposal.quorum_id, valutations: proposal.valutations, rank: proposal.rank, seq: 1)
      #save old authors
      proposal.users.each do |user|
        life.users << user
      end
      life.save!
      #delete old data
      proposal.valutations = 0
      proposal.rank = 0
      #proposal.quorum_id = nil

      #and authors
      proposal.proposal_presentations.destroy_all
      proposal.save!
    end
  end

  def down
    Proposal.where(proposal_state_id: ProposalState::ABANDONED).each do |proposal|
      life = proposal.proposal_lives.first
      life.users.each do |user|
        proposal.users << user
      end
      proposal.quorum = life.quorum
      proposal.valutations = life.valutations
      proposal.rank = life.rank
      life.destroy
      proposal.save!
    end

    drop_table :old_proposal_presentations

    drop_table :proposal_lives

    remove_column :quorums, :quorum_id

  end
end
