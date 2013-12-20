class AddDataToFeedback < ActiveRecord::Migration
  def up
    add_column :sent_feedbacks, :stack, :text
  end

  def down
    remove_column :sent_feedbacks, :stack
  end
end
