class CreateProposalSections < ActiveRecord::Migration
  def up

    #crea le soluzioni ad una proposta
    create_table :solutions do |t|
      t.integer :proposal_id, :null => false
      #t.string :title, :null => false, :limit => 100
      t.integer :seq, :null => false
    end
    add_foreign_key(:solutions,:proposals)

    #crea le sezioni
    create_table :sections do |t|
      #t.integer :proposal_id, :null => false
      t.string :title, :null => false, :limit => 100
      t.integer :seq, :null => false
    end

    create_table :proposal_sections do |t|
      t.integer :proposal_id, :null => false
      t.integer :section_id, :null => false
    end
    add_foreign_key(:proposal_sections,:proposals)
    add_foreign_key(:proposal_sections,:sections)
    add_index :proposal_sections, :section_id, :unique => true

    create_table :solution_sections do |t|
      t.integer :solution_id, :null => false
      t.integer :section_id, :null => false
    end
    add_foreign_key(:solution_sections,:solutions)
    add_foreign_key(:solution_sections,:sections)
    add_index :solution_sections, :section_id, :unique => true

    #ogni sezione ha più paragrafi (inizialmente solo uno)
    create_table :paragraphs do |t|
      t.integer :section_id, :null => false
      t.string :content, :null => true, :limit => 40000
      t.integer :seq, :null => false
    end
    add_foreign_key(:paragraphs,:sections)

    #i contributi fanno parte di un paragrafo
    add_column :proposal_comments, :paragraph_id, :integer, :null => true

    add_foreign_key(:proposal_comments,:paragraphs)

    Proposal.all.each do |p|
      prob = p.sections.create(:title => 'Problematica', :seq => 1)
      prob.paragraphs.create(:content => p.problems, :seq => 1)

      obj = p.sections.create(:title => 'Obiettivi', :seq => 2)
      obj.paragraphs.create(:content => p.objectives, :seq => 1)

      sol = p.solutions.create(:seq => 1)
      solsec = sol.sections.create(:title => 'Soluzione 1', :seq => 1)
      solsec.paragraphs.create(:content => p.content, :seq => 1)
    end

  end

  def down
    remove_column :proposal_comments, :paragraph_id
    drop_table :paragraphs
    drop_table :proposal_sections
    drop_table :solution_sections
    drop_table :sections
    drop_table :solutions
  end
end
