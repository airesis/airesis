#encoding: utf-8
class GroupPartecipationsController < ApplicationController
  include NotificationHelper

  #carica il gruppo
  before_filter :load_group_partecipation

  #sicurezza
  before_filter :authenticate_user!
  before_filter :verify

  def destroy

    @group_partecipation_request = GroupPartecipationRequest.find_by_user_id_and_group_id(@group_partecipation.user_id,@group_partecipation.group_id)

    if @group_partecipation.partecipation_role_id == PartecipationRole::PORTAVOCE &&
       @group_partecipation.group.portavoce.count == 1
      flash[:error] = "Non puoi uscire da un gruppo del quale sei l'unico portavoce"
    else
      GroupPartecipation.transaction do
        @group_partecipation_request.destroy
        @group_partecipation.destroy
      end
      flash[:notice] = "Sei uscito dal gruppo. Potrai successivamente richiedere di parteciparvi"
    end

    respond_to do |format|
      format.html { redirect_to :back }
      #format.xml  { head :ok }
    end
  end
  
  protected

  #verifica che l'utente abbia i permessi per eseguire l'operazione
  def verify
    unless current_user == @group_partecipation.user
      flash[:error] = t('error.permissions_required')
      redirect_to current_user
    end
  end

  
  def load_group_partecipation
    @group_partecipation = GroupPartecipation.find(params[:id])
  end
  
  
  
end
