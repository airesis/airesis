class DeleteRemovableQuora < ActiveRecord::Migration
  def up

    Quorum.where(removed: true).destroy_all
  end

  def down
    #i'm sorry, can't rollback this
  end
end
