class GenerateShortContentCache < ActiveRecord::Migration
  def change
    add_column :proposals, :short_content, :text, null: true
    Proposal.all.each do |proposal|
      proposal.update_columns(short_content: proposal.generate_short_content)
    end
  end
end
