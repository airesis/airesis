class RemoveOtherOldTutorial < ActiveRecord::Migration
  def up
    Step.find_by_fragment('proposals_show').update_attribute :format, 'js'
    Step.find_by_fragment('rank_bar_explain').destroy
  end

  def down
  end
end
