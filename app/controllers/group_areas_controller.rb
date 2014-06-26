#encoding: utf-8
class GroupAreasController < ApplicationController
  layout :choose_layout

  before_filter :authenticate_user!

  before_filter :configuration_required

  #carica il gruppo
  before_filter :load_group
  authorize_resource :group
  load_and_authorize_resource through: :group

  def index
    if @group.enable_areas
      @group_areas = @group.group_areas #.includes(:participants)
      @group_participations = @group.participants
    else
      render 'area_inactive'
    end
  end

  def show
    @page_title = @group_area.name
    @group_participations = @group_area.participants
  end

  def new
    @group_area = @group.group_areas.build
    @group_area.default_role_actions = DEFAULT_AREA_ACTIONS
  end

  def edit
    authorize! :update, @group_area
    @page_title = t('pages.groups.edit_work_areas.manage.title')
  end

  def edit_permissions
    @page_title = t("pages.groups.edit_permissions.title")
  end

  def create
    @group_area.current_user_id = current_user.id
    if @group_area.save
      @group_areas = @group.group_areas.includes(:participants)
      @group_participations = @group.participants
      flash[:notice] = t('info.groups.work_area.area_created')
      redirect_to [@group,@group_area]
    else
      respond_to do |format|
        flash[:error] = t('error.groups.work_area.area_created')
        format.html {render action: :new}
        format.js { render 'group_areas/errors/create' }
      end
    end
  end

  def update
    if @group_area.update_attributes(group_area_params)
      respond_to do |format|
          flash[:notice] = t('info.groups.group_updated')
          format.html { redirect_to([@group,@group_area]) }
      end
    else
      flash[:error] = t('error.groups.update')
      format.html { render action: :edit }
    end
  end


  def change
    group_area = GroupArea.find(params[:group_area_id])
    if params[:enable] == 'true'
      part = group_area.area_participations.new
      part.user_id = params[:user_id]
      part.area_role_id = group_area.area_role_id
      part.save!
    else
      group_area.area_participations.where(user_id: params[:user_id]).destroy_all
    end
  end


  def destroy
    authorize! :destroy, @group_area
    @group_area.destroy
  end

  def participants_list_panel
    @group_participations = @group_area.area_participations.includes(:user)
  end

  protected

  def group_area_params
    params.require(:group_area).permit(:name, :description, :default_role_name, :default_role_actions)
  end

  def configuration_required
    unless ::Configuration.group_areas
      flash[:error] = t('error.configuration_required')
      redirect_to edit_group_path(@group)
    end
  end

  private

  def choose_layout
    'groups'
  end
end
