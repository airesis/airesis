class AddRevisionState < ActiveRecord::Migration
  def up
    ProposalState.create(:description => 'revisione e feedback'){ |c| c.id = 7 }.save
  end

  def down
  end
end
