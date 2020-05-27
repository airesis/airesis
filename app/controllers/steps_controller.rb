class StepsController < ApplicationController
  before_action :load_tutorial

  # sign as completed a tutorial step
  def complete
    @step = @tutorial.steps.find(params[:id])
    assignee = current_user.tutorial_progresses.find_by(step_id: @step.id)
    assignee.update_attribute(:status, TutorialProgress::DONE)
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js { render nothing: true }
    end
  end

  protected

  def load_tutorial
    @tutorial = Tutorial.find(params[:tutorial_id])
  end
end
