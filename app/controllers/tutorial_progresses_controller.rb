class TutorialProgressesController < ApplicationController
  before_filter :admin_required
  # GET /tutorial_progresses
  # GET /tutorial_progresses.json
  def index
    @tutorial_progresses = TutorialProgress.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tutorial_progresses }
    end
  end

  # GET /tutorial_progresses/1
  # GET /tutorial_progresses/1.json
  def show
    @tutorial_progress = TutorialProgress.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @tutorial_progress }
    end
  end

  # GET /tutorial_progresses/new
  # GET /tutorial_progresses/new.json
  def new
    @tutorial_progress = TutorialProgress.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @tutorial_progress }
    end
  end

  # GET /tutorial_progresses/1/edit
  def edit
    @tutorial_progress = TutorialProgress.find(params[:id])
  end

  # POST /tutorial_progresses
  # POST /tutorial_progresses.json
  def create
    @tutorial_progress = TutorialProgress.new(params[:tutorial_progress])

    respond_to do |format|
      if @tutorial_progress.save
        format.html { redirect_to @tutorial_progress, notice: 'Tutorial progress was successfully created.' }
        format.json { render json: @tutorial_progress, status: :created, location: @tutorial_progress }
      else
        format.html { render action: "new" }
        format.json { render json: @tutorial_progress.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /tutorial_progresses/1
  # PUT /tutorial_progresses/1.json
  def update
    @tutorial_progress = TutorialProgress.find(params[:id])

    respond_to do |format|
      if @tutorial_progress.update_attributes(params[:tutorial_progress])
        format.html { redirect_to @tutorial_progress, notice: 'Tutorial progress was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @tutorial_progress.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tutorial_progresses/1
  # DELETE /tutorial_progresses/1.json
  def destroy
    @tutorial_progress = TutorialProgress.find(params[:id])
    @tutorial_progress.destroy

    respond_to do |format|
      format.html { redirect_to tutorial_progresses_url }
      format.json { head :ok }
    end
  end
end
