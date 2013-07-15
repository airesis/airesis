class SolutionTitles < ActiveRecord::Migration
  def up
    Solution.update_all("title = 'Soluzione ' || seq")
  end

  def down
  end
end
