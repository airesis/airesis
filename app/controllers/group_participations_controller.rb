class GroupParticipationsController < ApplicationController
  layout 'groups'

  before_filter :load_group

  before_filter :authenticate_user!

  load_and_authorize_resource :group
  load_and_authorize_resource through: :group, except: [:send_email, :destroy_all, :build_csv, :change_user_permission]

  def index
    @page_title = t('pages.group_participations.index.title')
    @search_participant = @group.search_participants.build(search_participant_params)
    @unscoped_group_participations = @search_participant.results
    @group_participations = @unscoped_group_participations.page(params[:page]).per(GroupParticipation::PER_PAGE)

    respond_to do |format|
      format.html
      format.js
      format.json
      format.csv { send_data build_csv }
    end
  end

  def build_csv
    authorize! :index, GroupParticipation
    CSV.generate do |csv|
      csv << [t('pages.groups.participations.surname'), t('pages.groups.participations.name'), t('pages.groups.participations.role'), t('pages.groups.participations.member_since')]
      @unscoped_group_participations.each do |group_participation|
        csv << [group_participation.user.surname, group_participation.user.name, group_participation.participation_role.name, group_participation.created_at ? (l group_participation.created_at) : ' ']
      end
    end
  end

  # changes the role of a user
  # TODO: move from here and put in group_participations#update
  def change_user_permission
    @group_participation = @group.group_participations.find(params[:id])
    @group_participation.participation_role = ParticipationRole.find(params[:participation_role_id])
    authorize! :change_user_permission, @group_participation
    @group_participation.save!
    flash[:notice] = t('info.participation_roles.role_changed')
    respond_to do |format|
      format.js { render partial: 'layouts/messages' }
    end
  end

  # send a massive email to all users
  # TODO: protect
  def send_email
    ids = params[:message][:receiver_ids]
    subject = params[:message][:subject]
    body = params[:message][:body]
    ResqueMailer.massive_email(current_user.id, ids, @group.id, subject, body).deliver_later
    flash[:notice] = t('info.message_sent')
  end

  # destroy all selected participations
  # TODO: check permissions
  def destroy_all
    ids = params[:destroy][:ids].split(',')
    GroupParticipation.transaction do
      ids.each do |id|
        group_participation = GroupParticipation.find(id)
        next unless group_participation.group == @group
        next if group_participation.user == current_user
        group_participation_request = GroupParticipationRequest.find_by_user_id_and_group_id(group_participation.user_id, group_participation.group_id)
        group_participation_request.destroy
        group_participation.destroy
        AreaParticipation.joins(group_area: :group).where(['groups.id = ? AND area_participations.user_id = ?', group_participation.group_id, group_participation.user_id]).readonly(false).destroy_all
      end
    end
    flash[:notice] = t('info.participations_destroyed')

  rescue Exception => e
    flash[:notice] = t('error.participations_destroyed')
    respond_to do |format|
      format.js do
        render :update do |page|
          page.replace_html 'flash_messages', partial: 'layouts/flash', locals: { flash: flash }
        end
      end
    end
  end

  def destroy
    @group_participation.destroy
    flash[:notice] =
      (current_user == @group_participation.user) ?
        t('info.group_participations.destroy_ok_1') :
        t('info.participation_roles.user_removed_from_group', name: @group_participation.user.fullname)

    redirect_to :back
  end

  protected

  def search_participant_params
    params[:search_participant] ? params.require(:search_participant).permit(:keywords, :role_id, :status_id) : {}
  end
end
