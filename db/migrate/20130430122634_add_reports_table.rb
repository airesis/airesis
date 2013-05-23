class AddReportsTable < ActiveRecord::Migration
  def up
    create_table :proposal_comment_report_types do |t|
      t.string :description, null: false, limit: 255
      t.integer :severity, null: false, default: 0
      t.integer :seq
    end
    create_table :proposal_comment_reports do |t|
      t.integer :proposal_comment_id, null: false
      t.integer :user_id, null: false
      t.integer :proposal_comment_report_type_id, null: false
    end

    add_foreign_key :proposal_comment_reports, :proposal_comment_report_types
    add_index :proposal_comment_reports, [:proposal_comment_id,:user_id], unique: true, name: 'reports_index'

    add_column :proposal_comments, :grave_reports_count, :integer, null: false, default: 0
    add_column :proposal_comments, :soft_reports_count, :integer, null: false, default: 0

    ProposalCommentReportType.create(description: 'Non attinente alla discussione o non costruttivo', seq: 1){ |c| c.id = 1 }.save
    ProposalCommentReportType.create(description: 'Duplicato', seq: 2){ |c| c.id = 2 }.save
    ProposalCommentReportType.create(description: 'Contenuti commerciali o spam', severity: 1, seq: 3){ |c| c.id = 3 }.save
    ProposalCommentReportType.create(description: 'Pornografia o materiale a carattere esplicitamente sessuale', severity: 1, seq: 4){ |c| c.id = 4 }.save
    ProposalCommentReportType.create(description: "Incitamento all'odio o violenza", severity: 1, seq: 5){ |c| c.id = 5 }.save
    ProposalCommentReportType.create(description: 'Materiale protetto da copyright', severity: 1, seq: 6){ |c| c.id = 6 }.save

  end

  def down
    remove_column :proposal_comments, :soft_reports_count
    remove_column :proposal_comments, :grave_reports_count
    drop_table :proposal_comment_reports
    drop_table :proposal_comment_report_types
  end
end
