class RemoveWrongEvents < ActiveRecord::Migration
  def up
    Event.where(:event_type_id => nil).destroy_all
    change_column :events, :event_type_id, :integer, null: false
  end

  def down
    change_column :events, :event_type_id, :integer, null: true
  end
end
