class ANewTutorialForOpenSpace < ActiveRecord::Migration
  include TutorialAssigneesHelper
  def up
    tutorial = Tutorial.create(action: "index", controller: "proposals", name: "Open Space", description: "Tutorial for Open Space" )
    step = Step.create(tutorial_id: tutorial.id,index: 0, title: "The Open Space and the proposals list", fragment: "proposals_index")
    User.all.each do |user|
      assign_tutorial(user,tutorial)
    end

  end

  def down
    Tutorial.find_by_action_and_controller('index','proposals').destroy
  end
end
