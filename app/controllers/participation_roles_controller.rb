class ParticipationRolesController < ApplicationController
  layout 'groups'

  before_filter :authenticate_user!

  before_filter :load_group

  authorize_resource :group
  before_filter :load_participation_roles, only: [:index]
  load_and_authorize_resource through: :group

  def index
    @page_title = t('pages.groups.edit_permissions.title')
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

  protected

  def load_participation_roles
    @participation_roles = @group.participation_roles
  end

  def participation_role_params
    params.require(:participation_role).
      permit(:id, :name, :description,
             :write_to_wall, :create_events, :support_proposals, :accept_participation_requests,
             :view_proposals, :participate_proposals, :insert_proposals, :vote_proposals,
             :choose_date_proposals, :view_documents, :manage_documents)
  end
end
