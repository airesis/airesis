class StepsController < ApplicationController
  # GET /steps
  # GET /steps.json
 before_filter :admin_required, :except => [:complete,:skip]
  
  before_filter :load_tutorial
  
  def index
    @steps = @tutorial.steps.all

    respond_to do |format|
      format.html # index.html.erb
     # format.json { render json: @steps }
    end
  end

  # GET /steps/1
  # GET /steps/1.json
  def show
    @step = @tutorial.steps.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
     # format.json { render json: @step }
    end
  end

  # GET /steps/new
  # GET /steps/new.json
  def new
    @step = @tutorial.steps.build

    respond_to do |format|
      format.html # new.html.erb
     # format.json { render json: @step }
    end
  end

  # GET /steps/1/edit
  def edit
    @step = @tutorial.steps.find(params[:id])
  end

  # POST /steps
  # POST /steps.json
  def create
    @step = @tutorial.steps.build(params[:step])

    respond_to do |format|
      if @step.save
        format.html { redirect_to [@tutorial,@step], notice: 'Step was successfully created.' }
     #   format.json { render json: @step, status: :created, location: @step }
      else
        format.html { render action: "new" }
      #  format.json { render json: @step.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /steps/1
  # PUT /steps/1.json
  def update
    @step = @tutorial.steps.find(params[:id])

    respond_to do |format|
      if @step.update_attributes(params[:step])
        format.html { redirect_to [@tutorial,@step], notice: 'Step was successfully updated.' }
     #   format.json { head :ok }
      else
        format.html { render action: "edit" }
     #   format.json { render json: @step.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /steps/1
  # DELETE /steps/1.json
  def destroy
    @step = @tutorial.steps.find(params[:id])
    @step.destroy

    respond_to do |format|
      format.html { redirect_to tutorial_url(@tutorial) }
   #   format.json { head :ok }
    end
  end
  
  #segna come completato uno step del tutorial
  def complete
    @step = @tutorial.steps.find(params[:id])
    assignee = current_user.tutorial_progresses.find_by_step_id(@step.id)
    assignee.update_attribute(:status,TutorialProgress::DONE)
    logger.info "User #{current_user.login} has completed fragment #{@step.fragment}"
    respond_to do |format|
      format.js { render :nothing => true }
      format.html { redirect_to :back }
    end

  end
  
  #segna come 'skipped' uno step del tutorial
  def skip
    
  end
  
  
  protected
   
  def load_tutorial
    @tutorial = Tutorial.find(params[:tutorial_id])
  end
end
