class Assigntutorials < ActiveRecord::Migration
  include TutorialAssigneesHelper
  
  def up
    User.all.each do |user|
      Tutorial.all.each do |tutorial|
        assign_tutorial(user,tutorial)
      end    
    end
  end

  def down
  end
end
