#encoding: utf-8
class AdminController < ApplicationController
  
  before_filter :admin_required#, :only => [:new, :create, :destroy]

  def index
   
  end
  
  def show        
   
  end
  
  #calcola il ranking degli utenti
  def calculate_ranking
    
    AdminHelper.calculate_ranking
    
    
    respond_to do |format|
      format.html {
        flash[:notice] = 'Ranking ricalcolato'
        redirect_to admin_panel_path
      }
    end
  end
  
  #cambia lo stato delle proposte
  def change_proposals_state
   AdminHelper.change_proposals_state
    
    respond_to do |format|
      format.html {        
        flash[:notice] = 'Stato proposte aggiornato'
        redirect_to admin_panel_path
      }
    end
  end
  
  def validate_groups
    AdminHelper.validate_groups
    
    
    respond_to do |format|
      format.html {
        flash[:notice] = 'Inviato elenco gruppi non validi'
        redirect_to admin_panel_path
      }
    end
  end
  
end
