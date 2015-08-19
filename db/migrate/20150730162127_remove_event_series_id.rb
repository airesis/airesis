class RemoveEventSeriesId < ActiveRecord::Migration
  def change
    remove_column :events, :event_series_id
  end
end
