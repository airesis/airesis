class CreateProposalTutorial < ActiveRecord::Migration
  def up
    tutorial = Tutorial.create(action: "new", controller: "proposals", name: "First Proposal", description: "Tutorial di spiegazione su come inserire la prima proposta" )
    Step.create(tutorial_id: tutorial.id,index: 0, title: "Breve spiegazione", fragment: "proposal_instructions")
    tutorial = Tutorial.create(action: "show", controller: "proposals", name: "Rank Bar", description: "Tutorial di spiegazione del funzionamento della ranking bar" )
    Step.create(tutorial_id: tutorial.id,index: 0, title: "Spiegazione Rank Bar", fragment: "rank_bar_explain")
  end

  def down
  end
end
