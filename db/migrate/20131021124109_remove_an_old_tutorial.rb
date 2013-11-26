class RemoveAnOldTutorial < ActiveRecord::Migration
  def up
    add_column :steps, :format, :string, default: 'html'
    Step.reset_column_information
    Step.find_by_fragment("proposals_index").update_attribute(:format,'js')
    Step.find_by_fragment("welcome").update_attribute(:format,'js')
    Step.find_by_fragment("rank_bar_explain").update_attribute(:format,'js')
    Step.find_by_fragment("choose_image").destroy
    Tutorial.find_by_name('Area candidature').destroy
  end

  def down
    remove_column :steps, :format
  end
end
