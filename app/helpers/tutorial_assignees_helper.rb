module TutorialAssigneesHelper
  def assign_tutorial(user,tutorial)
    tutorial_assignee = user.tutorial_assignees.build(tutorial: tutorial)
    tutorial.steps.each do |step|
      TutorialProgress.create(user_id: user.id,step_id: step.id)
    end
    tutorial_assignee.save
  end
end
