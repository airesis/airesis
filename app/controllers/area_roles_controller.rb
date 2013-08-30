#encoding: utf-8
class AreaRolesController < ApplicationController
  #include NotificationHelper

  layout :choose_layout

  #carica il gruppo
  before_filter :load_group

  before_filter :load_group_area

  before_filter :load_area_role, only: [:edit, :change, :update, :destroy, :change_permissions]

  ###SICUREZZA###

  #l'utente deve aver fatto login
  before_filter :authenticate_user!

  #l'utente deve essere amministratore
  #before_filter :admin_required, :only => [:destroy]

  #l'utente deve essere portavoce o amministratore
  before_filter :portavoce_required, :only => [:edit, :update, :edit_permissions]


  def new
    @area_role = @group_area.area_roles.build
  end

  def edit

  end

  #create new area role
  def create
    begin
      AreaRole.transaction do
        @group_area.area_roles.create(params[:area_role])
      end
      flash[:notice] = t('info.participation_roles.role_created')

    rescue ActiveRecord::ActiveRecordError => e
      respond_to do |format|
        flash[:error] = t('error.participation_roles.role_created')
        format.html { render :action => "new" }
      end
    end #begin
  end


  def update
    authorize! :update, @area_role
    AreaRole.transaction do
      @area_role.attributes = params[:area_role]
      @area_role.save!
    end

    flash[:notice] = t('area_role.confirm.update')

  rescue Exception => e
    respond_to do |format|
      flash[:error] = t('error.participation_roles.role_updated')
      format.js { render :update do |page|
        page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
      end }
    end
  end

  def destroy
    @area_role.destroy
    flash[:notice] = "Ruolo eliminato"
  end


  def change
    AreaActionAbilitation.transaction do
      if params[:block] == "true" #devo togliere i permessi
        abilitation = @area_role.area_action_abilitations.find_by_group_action_id_and_group_area_id(params[:action_id], params[:group_area_id])
        if (abilitation)
          abilitation.destroy
          flash[:notice] =t('info.participation_roles.permissions_updated')
        end
      else #devo abilitare
        abilitation = @area_role.area_action_abilitations.find_or_create_by_group_action_id_and_group_area_id(params[:action_id], params[:group_area_id])
        flash[:notice] =t('info.participation_roles.permissions_updated')
      end
    end

    respond_to do |format|
      format.js { render :update do |page|
        page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
      end
      }
    end
  end

  #modifica il ruolo di un utente all'interno di un gruppo
  def change_permissions
    gp = @group_area.area_partecipations.find_by_user_id(params[:user_id])
    gp.area_role_id = @area_role.id
    gp.save!
    flash[:notice] ="Ruolo modificato."
    respond_to do |format|
      format.js { render :update do |page|
        page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
      end
      }
    end
  end


  protected

  def load_group_area
    @group_area = GroupArea.find(params[:group_area_id])
  end

  def load_area_role
    @area_role = AreaRole.find(params[:id])
  end

  def portavoce_required
    if !((current_user && (@group.portavoce.include? current_user)) || is_admin?)
      flash[:error] = t('error.portavoce_required')
      redirect_to group_url(@group)
    end
  end

  private

  def choose_layout
    'groups'
  end
end
