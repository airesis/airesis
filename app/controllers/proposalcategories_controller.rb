class ProposalcategoriesController < ApplicationController
 
 # before_filter :login_required, :only => [ :edit, :update, :destroy, :new, :create ]
                
#  if logged_in?
#    puts "logged in"
#  else
#    puts "not logged in"
#  end
  
  
  def index
    @proposalcategories = ProposalCategory.find(:all, :order => "id desc")
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @proposalcategories }
    end
  end
  
#  # GET /topics/1
#  # GET /topics/1.xml
#  def show
#    @proposal = Proposal.find(params[:id])
#    author_id = ProposalPresentation.find_by_proposal_id(params[:id]).user_id
#    @author_name = User.find(author_id).name
#    
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @proposal }
#    end
#    
#  rescue
#    flash[:notice] = 'Errore nel caricamento della proposta.'
#    redirect_to proposals_path
#  end
#  
#  # GET /topics/new
#  # GET /topics/new.xml
#  def new
#    @proposal = Proposal.new
#    
#    respond_to do |format|
#      format.html # new.html.erb
#      format.xml  { render :xml => @proposal }
#    end
#  end
#  
#  # GET /topics/1/edit
#  def edit
#    @proposal = Proposal.find(params[:id])
#  end
#  
#  # POST /topics
#  # POST /topics.xml
#  def create
#    
#    @proposal = Proposal.new(params[:proposal])
#    psaved = @proposal.save
#    proposalparams = {
#          :proposal_id => @proposal.id,
#          :user_id => current_user.id
#    }
#    
#    @proposalpresentation = ProposalPresentation.new(proposalparams)
#    ppsaved = @proposalpresentation.save
#    
#    respond_to do |format|
#      if psaved && ppsaved
#        flash[:notice] = 'La tua proposta è stata inserita.'
#        format.html { redirect_to(proposals_url) }
#        format.xml  { render :xml => @proposal, :status => :created, :location => @proposal }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @proposal.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#  
#  # PUT /topics/1
#  # PUT /topics/1.xml
#  def update
#    @proposal = Proposal.find(params[:id])
#    
#    respond_to do |format|
#      if @proposal.update_attributes(params[:proposal])
#        flash[:notice] = 'Proposta aggiornata correttamente.'
#        format.html { redirect_to(proposals_url) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @proposal.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#  
#  # DELETE /topics/1
#  # DELETE /topics/1.xml
#  def destroy
#    @proposal = Proposal.find(params[:id])
#    @proposal.destroy
#    
#    respond_to do |format|
#      format.html { redirect_to(proposals_url) }
#      format.xml  { head :ok }
#    end
#  end
end
