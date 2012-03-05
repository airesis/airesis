#encoding: utf-8
class PartecipationRolesController < ApplicationController
  
  before_filter :load_group
  
  def create    
    begin
      PartecipationRole.transaction do
        
        role = PartecipationRole.new(params[:partecipation_role])
        role.save!               
      end
      
      respond_to do |format|
          flash[:notice] = 'Hai creato il ruolo.'
          format.html { redirect_to edit_permissions_group_path(@group) }          
      end 
    
    rescue ActiveRecord::ActiveRecordError => e
      respond_to do |format|
        flash[:error] = 'Errore nella creazione del ruolo.'
        format.js {  render :update do |page|
             page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
             end}
        format.html { redirect_to edit_permissions_group_path(@group) }                
      end          
    end 
  end 
   
  protected
  
  def load_group
    @group = Group.find(params[:partecipation_role][:group_id])
  end
  
end
