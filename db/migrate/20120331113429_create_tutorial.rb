class CreateTutorial < ActiveRecord::Migration
  def up
    tutorial = Tutorial.create(action: "show", controller: "home", name: "Welcome Tutorial", description: "Tutorial di benvenuto" )
    Step.create(tutorial_id: tutorial.id,index: 0, title: "Messaggio di benvenuto", fragment: "welcome")
    Step.create(tutorial_id: tutorial.id,index: 1, title: "Confini geografici di interesse", fragment: "interest_borders")
    Step.create(tutorial_id: tutorial.id,index: 2, title: "Scegli i gruppi", fragment: "choose_follow")
    Step.create(tutorial_id: tutorial.id,index: 3, title: "Prima proposta", fragment: "first_proposal")
    Step.create(tutorial_id: tutorial.id,index: 4, title: "Immagine", fragment: "choose_image")
  end

  def down
    
  end
end
