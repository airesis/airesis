class StepsController < ApplicationController
  before_filter :admin_required, except: [:complete, :skip]

  before_filter :load_tutorial

  def index
    @steps = @tutorial.steps.all

    respond_to do |format|
      format.html # index.html.erb
      # format.json { render json: @steps }
    end
  end

  def show
    @step = @tutorial.steps.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      # format.json { render json: @step }
    end
  end

  def new
    @step = @tutorial.steps.build

    respond_to do |format|
      format.html # new.html.erb
      # format.json { render json: @step }
    end
  end

  def edit
    @step = @tutorial.steps.find(params[:id])
  end

  def create
    @step = @tutorial.steps.build(params[:step])

    respond_to do |format|
      if @step.save
        format.html { redirect_to [@tutorial, @step], notice: 'Step was successfully created.' }
        #   format.json { render json: @step, status: :created, location: @step }
      else
        format.html { render action: 'new' }
        #  format.json { render json: @step.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @step = @tutorial.steps.find(params[:id])

    respond_to do |format|
      if @step.update_attributes(params[:step])
        format.html { redirect_to [@tutorial, @step], notice: 'Step was successfully updated.' }
        #   format.json { head :ok }
      else
        format.html { render action: 'edit' }
        #   format.json { render json: @step.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @step = @tutorial.steps.find(params[:id])
    @step.destroy

    respond_to do |format|
      format.html { redirect_to tutorial_url(@tutorial) }
      #   format.json { head :ok }
    end
  end

  # segna come completato uno step del tutorial
  def complete
    @step = @tutorial.steps.find(params[:id])
    assignee = current_user.tutorial_progresses.find_by_step_id(@step.id)
    assignee.update_attribute(:status, TutorialProgress::DONE)
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { render nothing: true }
    end
  end

  # segna come 'skipped' uno step del tutorial
  def skip
  end

  protected

  def load_tutorial
    @tutorial = Tutorial.find(params[:tutorial_id])
  end
end
