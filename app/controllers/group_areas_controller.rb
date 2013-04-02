#encoding: utf-8
class GroupAreasController < ApplicationController
  layout :choose_layout

  #carica il gruppo
  before_filter :load_group

  before_filter :load_group_area, only: [:show, :edit, :update, :destroy]

  ###SICUREZZA###

  #l'utente deve aver fatto login
  before_filter :authenticate_user!

  #l'utente deve essere amministratore
  #before_filter :admin_required, :only => [:destroy]

  #l'utente deve essere portavoce o amministratore
  before_filter :portavoce_required

  before_filter :configuration_required

  before_filter :areas_active_required, except: :index


  def index
    if @group.enable_areas
      @group_areas = @group.group_areas.includes(:partecipants)
      @partecipants = @group.partecipants
    else
      render 'area_inactive'
    end
  end

  def manage
    @group_areas = @group.group_areas.includes(:partecipants)
    @partecipants = @group.partecipants
  end


  def show
    @page_title = @group_area.name
    @partecipants = @group_area.partecipants
  end


  def new
    @group_area = @group.group_areas.build
    @group_area.default_role_actions = DEFAULT_AREA_ACTIONS
  end

  def edit
    authorize! :update, @group_area
    @page_title = t('pages.groups_area.edit.title')
  end

  def edit_permissions
    @page_title = t("pages.groups.edit_permissions.title")
  end

  #create new area
  def create
    begin
      GroupArea.transaction do

        params[:group_area][:default_role_actions]

        @group_area = @group.group_areas.build(params[:group_area]) #crea il gruppo
        @group_area.current_user_id = current_user.id
        @group_area.save!
      end
      flash[:notice] = t('controllers.group_areas.create.ok_message')

    rescue ActiveRecord::ActiveRecordError => e
      respond_to do |format|
        flash[:error] = t('controllers.group_areas.create.ko_message')
        format.js {
          render :update do |page|
            page.redirect_to group_group_areas_path(@group)
          end
        }
      end
    end #begin
  end

  #create

  def update
    authorize! :update, @group_area
    begin
      GroupArea.transaction do
        @group_area.attributes = params[:group_area]
      end

      respond_to do |format|
        if @group_area.save
          flash[:notice] = t('groups.confirm.update')
          format.html { redirect_to(@group) }
        else
          format.html { render :action => "edit" }
        end
      end
    rescue Exception => e
      puts e
      respond_to do |format|
        flash[:error] = t('groups.errors.update')
        format.html { render :action => "edit" }
      end
    end
  end


  def change
    group_area = GroupArea.find(params[:group_area_id])
    if params[:enable] == 'true'
      part = group_area.area_partecipations.new
      part.user_id = params[:user_id]
      part.area_role_id = group_area.area_role_id
      part.save!
    else
      group_area.area_partecipations.where(:user_id => params[:user_id]).destroy_all
    end
  end


  def destroy
    @group_area.destroy
  end

  def partecipants_list_panel
    @partecipants = @group_area.area_partecipations.includes(:user)
  end

  protected

  def load_group
    @group = Group.find(params[:group_id])
  end

  def load_group_area
    @group_area = GroupArea.find(params[:id])
  end

  def portavoce_required
    unless (current_user && (@group.portavoce.include? current_user)) || is_admin?
      flash[:error] = t('error.portavoce_required')
      redirect_to @group
    end
  end

  def configuration_required
    unless ::Configuration.group_areas
      flash[:error] = t('error.configuration_required')
      redirect_to edit_group_path(@group)
    end
  end

  def areas_active_required
    unless @group.enable_areas
      flash[:error] = t('error.areas_required')
      redirect_to edit_group_path(@group)
    end
  end

  private

  def choose_layout
    'groups'
  end
end
