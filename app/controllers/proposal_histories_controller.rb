#encoding: utf-8
class ProposalHistoriesController < ApplicationController
    
  #load_and_authorize_resource
  #carica la proposta
  before_filter :load_proposal
  
###SICUREZZA###
  
  #l'utente deve aver fatto login
  before_filter :authenticate_user!
    
  #mostra il pannello o la pagina sulla history della proposta  
  def index            
    respond_to do |format|     
      format.js 
      format.html # index.html.erb      
    end
  end
   
  def show    
    author_id = ProposalPresentation.find_by_proposal_id(params[:id]).user_id
    @author_name = User.find(author_id).name
    
    @proposal_comments = @proposal.comments.paginate(:page => params[:page],:per_page => COMMENTS_PER_PAGE, :order => 'created_at DESC')
    
    respond_to do |format|
      format.js
      format.html {
        if (@proposal.proposal_state_id == PROP_WAIT_DATE)
          flash.now[:notice] = "Questa proposta ha passato la fase di valutazione ed è ora in attesa di una data per la votazione."
        elsif (@proposal.proposal_state_id == PROP_VOTING)
          flash.now[:notice] = "Questa proposta è in fase di votazione."
        end                
      } # show.html.erb
     # format.xml  { render :xml => @proposal }
    end
  end
  
  def new
    @proposal = Proposal.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @proposal }
    end
  end
  
  def edit    
    
  end
  
  def create
    
  
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
