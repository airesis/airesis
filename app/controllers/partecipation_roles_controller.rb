#encoding: utf-8
class PartecipationRolesController < ApplicationController
  
  #l'utente deve aver fatto login
  before_filter :authenticate_user!
  
  before_filter :load_group, :except => [:destroy,:change_group_permission]
  before_filter :load_partecipation_role, :only => :destroy
  before_filter :check_permissions, :only => [:change_group_permission]
  
  def create    
    begin
      PartecipationRole.transaction do
        
        @role = PartecipationRole.new(params[:partecipation_role])
        @role.save!               
      end
      
    
    
      respond_to do |format|
          flash[:notice] = 'Hai creato il ruolo.'
          format.js { render :update do |page|
                     page.redirect_to edit_permissions_group_path(@group)
                  end
      }
          format.html { redirect_to edit_permissions_group_path(@group) }          
      end 
    
    rescue ActiveRecord::ActiveRecordError => e
      respond_to do |format|
        flash[:error] = 'Errore nella creazione del ruolo.'
        format.js {  render :update do |page|
               page.alert @role.errors.full_messages.join(";")
        end}
        format.html { redirect_to edit_permissions_group_path(@group) }                
      end          
    end 
  end 
  
  
  def destroy
    if @partecipation_role.destroy
      flash[:notice] = "Ruolo eliminato"
    end
    respond_to do |format|
      format.js { render :update do |page|
                     page.redirect_to edit_permissions_group_path(@partecipation_role.group)
                  end
      }
    end
  end
  
  
  def change_group_permission
   
    ActionAbilitation.transaction do
      if(params[:block] == "true") #devo togliere i permessi
        abilitation = @role.action_abilitations.find_by_group_action_id_and_partecipation_role_id(params[:action_id],params[:role_id])
        if (abilitation)
          abilitation.destroy
          flash[:notice] ="Permessi aggiornati."
        end
      else #devo abilitare
        abilitation = @role.action_abilitations.find_or_create_by_group_action_id_and_partecipation_role_id_and_group_id(params[:action_id],params[:role_id],params[:group_id])
        flash[:notice] ="Permessi aggiornati."    
      end  
    end
        
    respond_to do |format|
      format.js { render :update do |page|
                     page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
                  end
      }
    end
  end
   
  protected
  
  def check_permissions
    @group = Group.find(params[:group_id])
    @role = PartecipationRole.find(params[:role_id])
    if !((current_user && (@group.portavoce == current_user)) || is_admin?) || (@group != @role.group)
      flash[:error] = t('error.role_permission_change')
      respond_to do |format|
      format.js { render :update do |page|
                     page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
                  end
      }
      end
      return false
    end
  end
  
  def load_partecipation_role
    @partecipation_role = PartecipationRole.find(params[:id])
  end
  
  def load_group
    @group = Group.find(params[:partecipation_role][:group_id])
  end
  
end
