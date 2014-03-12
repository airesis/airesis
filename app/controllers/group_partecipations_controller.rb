#encoding: utf-8
class GroupPartecipationsController < ApplicationController
  include NotificationHelper

  layout 'groups'

  #carica il gruppo
  before_filter :load_group

  before_filter :load_group_partecipation, :except => [:index, :send_email, :destroy_all]

  #sicurezza
  before_filter :authenticate_user!


  def index
    @partecipants = @group.group_partecipations.search(params[:search])

    respond_to do |format|
      format.html
      format.js
      format.csv { send_data build_csv }
    end
  end

  def build_csv
    CSV.generate do |csv|
      csv << [t('pages.groups.participations.surname'), t('pages.groups.participations.name'), t('pages.groups.participations.role'), t('pages.groups.participations.member_since')]
      @partecipants.each do |group_partecipation|
        csv << [group_partecipation.user.surname, group_partecipation.user.name, group_partecipation.partecipation_role.name, group_partecipation.created_at ? (l group_partecipation.created_at) : ' ']
      end
    end
  end


  #send a massive email to all users
  def send_email
    ids = params[:message][:receiver_ids]
    subject = params[:message][:subject]
    body = params[:message][:body]
    ResqueMailer.delay.massive_email(current_user.id, ids, @group.id, subject, body)
    flash[:notice] = t('info.message_sent')
  end

  #destroy all selected participations
  def destroy_all
    ids = params[:destroy][:ids].split(',')
    GroupPartecipation.transaction do
      ids.each do |id|
        group_partecipation = GroupPartecipation.find(id)
        if group_partecipation.group == @group
          unless group_partecipation.user == current_user
            group_partecipation_request = GroupPartecipationRequest.find_by_user_id_and_group_id(group_partecipation.user_id, group_partecipation.group_id)
            group_partecipation_request.destroy
            group_partecipation.destroy
            AreaPartecipation.joins(:group_area => :group).where(['groups.id = ? AND area_partecipations.user_id = ?', group_partecipation.group_id, group_partecipation.user_id]).readonly(false).destroy_all
          end
        end
      end
    end
    flash[:notice] = t('info.participations_destroyed')

  rescue Exception => e
    flash[:notice] = t('error.participations_destroyed')
    respond_to do |format|
      format.js { render :update do |page|
        page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
      end }
    end
  end


  def destroy
    authorize! :destroy, @group_partecipation

    @group_partecipation_request = GroupPartecipationRequest.find_by_user_id_and_group_id(@group_partecipation.user_id, @group_partecipation.group_id)

    if (@group_partecipation.partecipation_role_id == PartecipationRole::PORTAVOCE) &&
        (@group_partecipation.group.portavoce.count == 1)
      flash[:error] = t('error.group_partecipations.destroy')
    else
      GroupPartecipation.transaction do
        @group_partecipation_request.destroy
        @group_partecipation.destroy
        AreaPartecipation.joins(:group_area => :group).where(['groups.id = ? AND area_partecipations.user_id = ?', @group_partecipation.group_id, @group_partecipation.user_id]).readonly(false).destroy_all
      end
      flash[:notice] = current_user == @group_partecipation.user ? t('info.group_partecipations.destroy_ok_1') : I18n.t('info.participation_roles.user_removed_from_group', name: @group_partecipation.user.fullname)
    end

    respond_to do |format|
      format.html { redirect_to :back }
    end
  end

  protected

  def load_group_partecipation
    @group_partecipation = GroupPartecipation.find(params[:id])
  end


end
