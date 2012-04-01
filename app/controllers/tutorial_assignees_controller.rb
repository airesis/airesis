class TutorialAssigneesController < ApplicationController
   before_filter :admin_required
  # GET /steps
  # GET /steps.json
  
  before_filter :load_tutorial
  
  
  def index
    @tutorial_assignees = @tutorial.assignees.all

    respond_to do |format|
      format.html # index.html.erb
      #format.json { render json: @tutorial_assignees }
    end
  end

  # GET /tutorial_assignees/1
  # GET /tutorial_assignees/1.json
  def show
    @tutorial_assignee = @tutorial.assignees.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    #  format.json { render json: @tutorial_assignee }
    end
  end

  # GET /tutorial_assignees/new
  # GET /tutorial_assignees/new.json
  def new
    @tutorial_assignee = @tutorial.assignees.build

    respond_to do |format|
      format.html # new.html.erb
   #   format.json { render json: @tutorial_assignee }
    end
  end

  # GET /tutorial_assignees/1/edit
  def edit
    @tutorial_assignee = @tutorial.assignees.find(params[:id])
  end

  # POST /tutorial_assignees
  # POST /tutorial_assignees.json
  def create
    @tutorial_assignee = @tutorial.assignees.build(params[:tutorial_assignee])
    @tutorial.steps.each do |step|
      TutorialProgress.create(:user_id => @tutorial_assignee.user_id,:step_id => step.id)
    end
    respond_to do |format|
      if @tutorial_assignee.save
        format.html { redirect_to @tutorial, notice: 'Tutorial assignee was successfully created.' }
     #   format.json { render json: @tutorial_assignee, status: :created, location: @tutorial_assignee }
      else
        format.html { render action: "new" }
    #    format.json { render json: @tutorial_assignee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tutorial_assignees/1
  # PUT /tutorial_assignees/1.json
  def update
    @tutorial_assignee = @tutorial.assignees.find(params[:id])

    respond_to do |format|
      if @tutorial_assignee.update_attributes(params[:tutorial_assignee])
        format.html { redirect_to @tutorial, notice: 'Tutorial assignee was successfully updated.' }
     #   format.json { head :ok }
      else
        format.html { render action: "edit" }
    #    format.json { render json: @tutorial_assignee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tutorial_assignees/1
  # DELETE /tutorial_assignees/1.json
  def destroy
    @tutorial_assignee = @tutorial.assignees.find(params[:id])
    @tutorial_assignee.destroy

    respond_to do |format|
      format.html { redirect_to @tutorial }
    #  format.json { head :ok }
    end
  end
  
  
   protected
   
  def load_tutorial
    @tutorial = Tutorial.find(params[:tutorial_id])
  end
end
