class RemoveOldTitles < ActiveRecord::Migration
  def up
    Solution
    .where(:title => ['Soluzione 1','Soluzione 2','Soluzione 3','Soluzione 4','Soluzione 5','Soluzione 6','Soluzione 7','Soluzione 8','Soluzione 9','Soluzione 10','Soluzione 11','Soluzione 12','Soluzione 13','Soluzione 14','Soluzione 15','Soluzione 16','Soluzione 17','Soluzione 18','Soluzione 19','Soluzione 20','Solution 1','Solution 2'])
    .update_all(title: nil)
    SolutionHistory
    .where(:title => ['Soluzione 1','Soluzione 2','Soluzione 3','Soluzione 4','Soluzione 5','Soluzione 6','Soluzione 7','Soluzione 8','Soluzione 9','Soluzione 10','Soluzione 11','Soluzione 12','Soluzione 13','Soluzione 14','Soluzione 15','Soluzione 16','Soluzione 17','Soluzione 18','Soluzione 19','Soluzione 20','Solution 1','Solution 2'])
    .update_all(title: nil)

  end

  def down
  end
end
