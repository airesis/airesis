class AddSomeUsefulColumns < ActiveRecord::Migration
  def up



    add_column :paragraph_histories, :proposal_id, :integer
    add_index :paragraph_histories, :proposal_id
    add_foreign_key :paragraph_histories, :proposals

    ProposalRevision.all.each do |revision|
      if revision.proposal
      revision.section_histories.each do |section|
        section.paragraphs.update_all({proposal_id: revision.proposal_id})
      end
      revision.solution_histories.each do |solution|
        solution.section_histories.each do |section|
          section.paragraphs.update_all({proposal_id: revision.proposal_id})
        end
      end
      else
        revision.destroy
      end

    end

    add_index :proposal_revisions, :proposal_id
    add_foreign_key :proposal_revisions, :proposals

    add_index :solution_histories, :proposal_revision_id
    add_foreign_key :solution_histories, :proposal_revisions

    add_index :revision_section_histories, :proposal_revision_id
    add_index :revision_section_histories, :section_history_id
    add_foreign_key :revision_section_histories, :proposal_revisions
    add_foreign_key :revision_section_histories, :section_histories

    add_index :solution_section_histories, :solution_history_id
    add_index :solution_section_histories, :section_history_id
    add_foreign_key :solution_section_histories, :solution_histories
    add_foreign_key :solution_section_histories, :section_histories

    change_column :paragraph_histories, :proposal_id, :integer, null: false

  end

  def down
    remove_column :paragraph_histories, :proposal_id
  end
end
