class AddTimestampsToGroup < ActiveRecord::Migration
  def change
    add_timestamps(:groups)
  end
end
