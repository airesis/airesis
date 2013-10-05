class RemoveOldQuorums < ActiveRecord::Migration
  def up
    Quorum.where({public: true, name: ['Veloce','Normale','Lunga','Buon punteggio']}).destroy_all
  end

  def down
  end
end
