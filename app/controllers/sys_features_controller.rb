class SysFeaturesController < ApplicationController
  layout 'open_space'

  before_filter :moderator_required, except: [:index,:show]

  def index
    @sys_features = SysFeature.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sys_features }
    end
  end

  # GET /sys_features/1
  # GET /sys_features/1.json
  def show
    @sys_feature = SysFeature.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sys_feature }
    end
  end

  # GET /sys_features/new
  # GET /sys_features/new.json
  def new
    @sys_feature = SysFeature.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sys_feature }
    end
  end

  # GET /sys_features/1/edit
  def edit
    @sys_feature = SysFeature.find(params[:id])
  end

  # POST /sys_features
  # POST /sys_features.json
  def create
    @sys_feature = SysFeature.new(params[:sys_feature])

    respond_to do |format|
      if @sys_feature.save
        format.html { redirect_to @sys_feature, notice: 'Sys feature was successfully created.' }
        format.json { render json: @sys_feature, status: :created, location: @sys_feature }
      else
        format.html { render action: "new" }
        format.json { render json: @sys_feature.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sys_features/1
  # PUT /sys_features/1.json
  def update
    @sys_feature = SysFeature.find(params[:id])

    respond_to do |format|
      if @sys_feature.update_attributes(params[:sys_feature])
        format.html { redirect_to @sys_feature, notice: 'Sys feature was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @sys_feature.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sys_features/1
  # DELETE /sys_features/1.json
  def destroy
    @sys_feature = SysFeature.find(params[:id])
    @sys_feature.destroy

    respond_to do |format|
      format.html { redirect_to sys_features_url }
      format.json { head :no_content }
    end
  end
end
