#encoding: utf-8
class ParticipationRolesController < ApplicationController
  layout 'groups'

  #l'utente deve aver fatto login
  before_filter :authenticate_user!

  before_filter :load_group
  authorize_resource :group
  load_and_authorize_resource through: :group

  def index
    @page_title = t("pages.groups.edit_permissions.title")
  end

  def new
    @page_title = t('pages.groups.edit_permissions.new_role_title')
  end

  def create
    if @participation_role.save
      respond_to do |format|
        flash[:notice] = t('info.participation_roles.role_created')
        format.html { redirect_to group_participation_roles_path(@group) }
        format.js
      end
    else
      respond_to do |format|
        flash[:error] = t('error.participation_roles.role_created')
        format.html { render 'new' }
        format.js { render 'participation_roles/errors/create' }
      end
    end
  end

  def edit
    @page_title = t('pages.participation_roles.edit.title')
  end

  def update
    @participation_role.attributes = participation_role_params
    if @participation_role.save
      @participation_roles = @group.participation_roles
      respond_to do |format|
        flash[:notice] = t('info.participation_roles.role_updated')
        format.html { redirect_to group_participation_roles_path(@group) }
        format.js
      end
    else
      respond_to do |format|
        flash[:error] = t('error.participation_roles.role_updated')
        format.js { render 'layouts/error' }
      end
    end
  end

  def destroy
    if @participation_role.destroy
      flash[:notice] = t('info.participation_roles.role_deleted')
    end
    redirect_to group_participation_roles_path(@group)
  end

  #change role permissions
  #todo move from here and put in action_abilitation#create and action_abilitations#destroy
  def change_group_permission
    ActionAbilitation.transaction do
      if params[:block] == "true" #devo togliere i permessi
        abilitation = @participation_role.action_abilitations.where(group_action_id: params[:action_id])
        if abilitation.exists?
          flash[:notice] = t('info.participation_roles.permissions_updated')
          abilitation.destroy_all
        end
      else #devo abilitare
        flash[:notice] = t('info.participation_roles.permissions_updated')
        @participation_role.action_abilitations.create!(group_action_id: params[:action_id], group_id: params[:group_id])

      end
    end

    respond_to do |format|
      format.js { render partial: 'layouts/messages' }
    end
  end

  protected

  def participation_role_params
    params.require(:participation_role).permit(:id, :parent_participation_role_id, :name, :description)
  end
end
