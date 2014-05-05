class CandidatesIndexTutorial < ActiveRecord::Migration
  include TutorialAssigneesHelper
  def up
     tutorial = Tutorial.create(action: "index", controller: "candidates", name: "Area candidature", description: "Tutorial di spiegazione sulla pagina delle candidature" )
     step = Step.create(tutorial_id: tutorial.id,index: 0, title: "La pagina delle candidature del gruppo", fragment: "candidates_index")
     User.all.each do |user|
      assign_tutorial(user,tutorial)
     end
  end

  def down
  end
end
