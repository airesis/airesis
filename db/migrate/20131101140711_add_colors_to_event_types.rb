class AddColorsToEventTypes < ActiveRecord::Migration
  def up
    add_column :event_types, :color, :string, limit: 10
    EventType.reset_column_information
    EventType.find_by_name('vote').update_attribute(:color,'#C7E4C8')
    EventType.find_by_name('meeting').update_attribute(:color,'#EDD4B6')
  end

  def down
    remove_column :event_types, :color
  end
end
