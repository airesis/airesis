class AddScoreToCandidates < ActiveRecord::Migration
  def up
     add_column :candidates, :score, :integer
     add_column :elections, :score_calculated, :boolean, default: false
  end

  def down
    drop_colum :candidates, :score
    drop_column :elections, :score_calculated
  end
end
