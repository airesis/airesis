class ProposalsShowTutorial < ActiveRecord::Migration
  include TutorialAssigneesHelper
  def up
     tutorial = Tutorial.find_by_action_and_controller("show","proposals")
     step = Step.create(:tutorial_id => tutorial.id,:index => 0, :title => "L'anonimato nella discussione", :fragment => "proposals_show")    
     User.all.each do |user|
      assign_tutorial(user,tutorial)
     end
  end

  def down
  end
end
