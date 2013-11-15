class NewProposalTutorial < ActiveRecord::Migration
  def up
    Step.find_by_fragment('proposal_instructions').update_attributes({fragment: 'proposals_new', format: 'js'})
  end

  def down
  end
end
