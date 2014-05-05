class AddGroupActionCandidates < ActiveRecord::Migration
  def up
    GroupAction.create(name: "SEND_CANDIDATES", description: 'Inviare candidati alle elezioni')
  end

  def down
  end
end
