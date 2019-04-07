class AreaRolesController < ApplicationController
  layout :choose_layout

  before_action :load_group

  authorize_resource :group
  load_and_authorize_resource :group_area, through: :group
  load_and_authorize_resource through: :group_area

  def new
  end

  def edit
  end

  def create
    respond_to do |format|
      if @area_role.save
        flash[:notice] = t('info.participation_roles.role_created')
        format.html { redirect_to [@group, @group_area] }
        format.js
      else
        flash[:error] = t('error.participation_roles.role_created')
        format.html { render action: :new }
        format.js { render 'layouts/active_record_error', locals: { object: @area_role } }
      end
    end
  end

  def update
    if @area_role.update_attributes(area_role_params)
      flash[:notice] = t('info.participation_roles.role_updated')
    else
      respond_to do |format|
        flash[:error] = t('error.participation_roles.role_updated')
        format.js { render 'layouts/success' }
      end
    end
  end

  def destroy
    @area_role.destroy
    flash[:notice] = t('info.participation_roles.role_deleted')
  end

  def change_permissions
    gp = @group_area.area_participations.find_by(user_id: params[:user_id])
    gp.area_role_id = @area_role.id
    gp.save!
    flash[:notice] = t('info.participation_roles.role_changed')
    respond_to do |format|
      format.js { render 'layouts/success' }
    end
  end

  protected

  def area_role_params
    params[:area_role].
      permit(:name, :description,
             :view_proposals, :participate_proposals, :insert_proposals, :vote_proposals, :choose_date_proposals)
  end

  def load_group_area
    @group_area = GroupArea.find(params[:group_area_id])
  end

  def load_area_role
    @area_role = AreaRole.find(params[:id])
  end

  def portavoce_required
    unless (current_user && (@group.portavoce.include? current_user)) || is_admin?
      flash[:error] = t('error.portavoce_required')
      redirect_to group_url(@group)
    end
  end

  private

  def choose_layout
    'groups'
  end
end
