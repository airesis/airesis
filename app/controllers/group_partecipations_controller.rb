#encoding: utf-8
class GroupPartecipationsController < ApplicationController
  include NotificationHelper


  layout 'groups'

  #carica il gruppo
  before_filter :load_group

  before_filter :load_group_partecipation, :except => :index

  #sicurezza
  before_filter :authenticate_user!


  def index
    @group_partecipations = @group.group_partecipations.joins(:user).reorder(:surname)
    @partecipants = @group.group_partecipations.includes(:user)
    respond_to do |format|
      format.html
      format.js
      format.csv { send_data build_csv }
    end
  end

  def build_csv
    CSV.generate do |csv|
      csv << ['Cognome','Nome','Ruolo','Iscritto dal']
      @group_partecipations.each do |group_partecipation|
        csv << [group_partecipation.user.surname,group_partecipation.user.name,group_partecipation.partecipation_role.name,group_partecipation.created_at ? (l group_partecipation.created_at) : ' ']
      end
    end
  end

  def destroy
    authorize! :destroy, @group_partecipation

    @group_partecipation_request = GroupPartecipationRequest.find_by_user_id_and_group_id(@group_partecipation.user_id,@group_partecipation.group_id)

    if @group_partecipation.partecipation_role_id == PartecipationRole::PORTAVOCE &&
       @group_partecipation.group.portavoce.count == 1
      flash[:error] = "Non puoi uscire da un gruppo del quale sei l'unico portavoce"
    else
      GroupPartecipation.transaction do
        @group_partecipation_request.destroy
        @group_partecipation.destroy
      end
      flash[:notice] = current_user == @group_partecipation.user ? "Sei uscito dal gruppo. In futuro potrai richiedere nuovamente di parteciparvi" : "#{@group_partecipation.user.fullname} rimosso correttamente dal gruppo"
    end

    respond_to do |format|
      format.html { redirect_to :back }
      #format.xml  { head :ok }
    end
  end
  
  protected

  def load_group_partecipation
    @group_partecipation = GroupPartecipation.find(params[:id])
  end

  def load_group
    @group = Group.find(params[:group_id])
  end
  
  
end
