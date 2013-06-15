#encoding: utf-8
class GroupPartecipationsController < ApplicationController
  include NotificationHelper

  #carica il gruppo
  before_filter :load_group_partecipation

  #sicurezza
  before_filter :authenticate_user!

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
  
  
  
end
