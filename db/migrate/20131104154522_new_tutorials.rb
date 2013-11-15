class NewTutorials < ActiveRecord::Migration
  include TutorialAssigneesHelper
  def up
    tutorial = Tutorial.create(:action => "edit", :controller => "groups", :name => "Nuovo menu Impostazioni")
    step = Step.create(:tutorial_id => tutorial.id,:index => 0, :title => "Il nuovo MENU Impostazioni", :fragment => "groups_edit", format: 'js')
    User.all.each do |user|
      assign_tutorial(user,tutorial)
    end
  end

  def down
    Tutorial.find_by_action_and_controller('edit','groups').destroy
  end

end
