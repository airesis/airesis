class NewHistoryWay < ActiveRecord::Migration
  def up
    create_table :proposal_revisions do |t|
      t.integer :proposal_id
      t.integer :user_id
      t.integer :valutations
      t.integer :rank
      t.integer :seq, null: false
      t.timestamps
    end

    create_table :section_histories do |t|
      t.integer :section_id
      t.string :title, limit: 100, null: false
      t.integer :seq, null: false
    end

    create_table :paragraph_histories do |t|
      t.integer :section_history_id, null: false
      t.string :content, limit: 40000
      t.integer :seq, null: false
    end

    create_table :solution_histories do |t|
      t.integer :proposal_revision_id, null: false
      t.integer :seq, null: false
    end

    create_table :solution_section_histories do |t|
      t.integer :solution_history_id, null: false
      t.integer :section_history_id, null: false
    end

    create_table :revision_section_histories do |t|
      t.integer :proposal_revision_id, null: false
      t.integer :section_history_id, null: false
    end


    execute "update paragraphs set content = regexp_replace(content,'\r\n','<br />', 'g');"

    Proposal.all.each do |proposal|
      histories = proposal.proposal_histories.order("created_at asc")
      seq = 1
      histories.each do |history|
        revision = proposal.revisions.build(user_id: history.user_id, valutations: history.valutations, rank: history.rank, seq: seq, created_at: history.created_at, updated_at: history.updated_at)
        if history.content
          solution = proposal.solutions.first
          solution_history = revision.solution_histories.build(seq: solution.seq)
          section = solution.sections.first
          section_history = solution_history.section_histories.build(section_id: section.id, title: section.title, seq: section.seq)
          section_history.paragraphs.build(content: section.paragraphs.first.content, seq: 1)
        end
        if history.problem
          section = proposal.sections.where(:title => 'Problematica').first
          section_history = revision.section_histories.build(section_id: section.id, title: section.title, seq: section.seq)
          section_history.paragraphs.build(content: section.paragraphs.first.content, seq: 1)
        end
        revision.save!
        seq+=1
      end
    end
  end

  def down
    drop_table :revision_section_histories
    drop_table :solution_section_histories
    drop_table :solution_histories
    drop_table :paragraph_histories
    drop_table :section_histories
    drop_table :proposal_revisions
  end
end

