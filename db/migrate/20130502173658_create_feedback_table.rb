class CreateFeedbackTable < ActiveRecord::Migration
  def up
    create_table :sent_feedbacks do |t|
      t.attachment :image
      t.text :message
      t.string :email, limit: 255
    end
  end

  def down
    drop_table :sent_feedbacks
  end
end
