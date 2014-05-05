class AddElectionEventType < ActiveRecord::Migration
  def up
    EventType.create(description: 'elezioni')
  end

  def down
  end
end