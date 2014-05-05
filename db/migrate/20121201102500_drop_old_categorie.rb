class DropOldCategorie < ActiveRecord::Migration
  def up
    ProposalCategory.all(conditions: ['id in (?)', [1,2,3,4,6]]).each do |category|
      category.destroy
    end    
  end

  def down
  end
end
