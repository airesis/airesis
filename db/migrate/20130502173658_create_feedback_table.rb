class CreateFeedbackTable < ActiveRecord::Migration
  def up
    create_table :sent_feedback do |t|
      t.attachment :image
      t.text :message
    end
  end

  def down
    drop_table :sent_feedback
  end
end
