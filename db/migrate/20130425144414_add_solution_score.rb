class AddSolutionScore < ActiveRecord::Migration
  def up
    add_column :solutions, :schulze_score, :integer, null:true
  end

  def down
  end
end
