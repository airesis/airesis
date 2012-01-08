#encoding: utf-8
class AdminController < ApplicationController
  
  before_filter :admin_required#, :only => [:new, :create, :destroy]

  def index
   
  end
  
  def show        
   
  end
  
  #calcola il ranking degli utenti
  def calculate_ranking
    
    AdminHelper.new.calculate_ranking
    
    
    respond_to do |format|
      format.html {
        flash[:notice] = 'Ranking ricalcolato per '+ @users.count.to_s+' utenti'
        redirect_to admin_panel_path
      }
    end
  end
  
  #cambia lo stato delle proposte
  def change_proposals_state
   AdminHelper.new.change_proposals_state
    
    respond_to do |format|
      format.html {        
        flash[:notice] = denied.to_s + ' proposte sono state RESPINTE, ' + accepted.to_s + ' proposte sono state ACCETTATE, ' + counter.to_s + ' proposte sono passate in VOTAZIONE'
        redirect_to admin_panel_path
      }
    end
  end
  
end
