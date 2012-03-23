#encoding: utf-8
class ProposalSupportsController < ApplicationController
    
  #load_and_authorize_resource
  #carica la proposta
  before_filter :load_proposal
  
###SICUREZZA###
  
  #l'utente deve aver fatto login
  before_filter :authenticate_user!
    
  def index
    
  end  
  
  #mostra il pannello o la pagina per fornire supporto alla proposta da parte di un gruppo
  def new            
    @proposal_support = @proposal.proposal_supports.build
    respond_to do |format|     
      format.js 
      format.html # index.html.erb      
    end
  end
   
  def create    
    puts "create"
    @proposal.group_ids = params[:proposal][:group_ids]
    @proposal.save
    flash[:notice] = "Sostegno alla proposta salvato correttamente"
    respond_to do |format|     
      format.js 
      format.html # index.html.erb      
    end
    
  rescue ActiveRecord::ActiveRecordError => e
    respond_to do |format|     
      format.js do
        render :update do |page|
          page.alert "Errore durante l'operazione" 
        end 
      end
      format.html redirect_to proposal_path(@proposal)# index.html.erb      
    end
    
  end  
  
  def edit    
    
  end
  
  def update
  
  end
  
  
  def destroy
    
  end
  
  
  protected
 
  def load_proposal
    @proposal = Proposal.find(params[:proposal_id])
  end
  
end
