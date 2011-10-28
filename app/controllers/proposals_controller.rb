#encoding: utf-8
class ProposalsController < ApplicationController
  include AuthenticatedSystem
  
  before_filter :load_proposal, :except => [:index, :new, :create, :index_by_category]
  before_filter :login_required, :only => [ :edit, :update, :destroy, :new, :create ]
  before_filter :check_author, :only => [:edit, :update, :destroy]
  before_filter :can_valutate, :only => [:rankup,:rankdown]
  before_filter :valutation_state_required, :only => [:edit,:update,:rankup,:rankdown,:destroy]
  
  
  
  def index
    #se è stata scelta una categoria, filtra per essa
    if (params[:category])
        @category = ProposalCategory.find_by_id(params[:category])
        @proposals = Proposal.find(:all,:conditions => ["proposal_category_id = ?",params[:category]],:order => "created_at desc")
    else #altrimenti ordina per data di creazione
        @proposals = Proposal.find(:all,:order => "created_at desc")
    end
    
    if (params[:view] == ORDER_BY_RANK)
      @proposals.sort! { |a,b| b.rank <=> a.rank }
    elsif (params[:view] == ORDER_BY_VOTES)
      @proposals.sort!{ |a,b| b.valutations <=> a.valutations }  
    end  
    
    respond_to do |format|     
      format.html # index.html.erb
      
    end
  end
  
  
  def show    
    author_id = ProposalPresentation.find_by_proposal_id(params[:id]).user_id
    @author_name = User.find(author_id).name
    
    if (@proposal.proposal_state_id == PROP_WAIT_DATE)
      flash.now[:notice] = "Questa proposta ha passato la fase di valutazione ed è ora in attesa di una data per la votazione."
    elsif (@proposal.proposal_state_id == PROP_VOTING)
      flash.now[:notice] = "Questa proposta è in fase di votazione."
    end
    
    @proposal_comments = @proposal.comments.paginate(:page => params[:page],:per_page => COMMENTS_PER_PAGE, :order => 'created_at DESC')
    
    respond_to do |format|
      format.html # show.html.erb
      format.js do
        render :update do |page|
          page.replace_html "proposalCommentsContainer", :partial => "proposals/comments"
        end
      end
      format.xml  { render :xml => @proposal }
    end
    
  rescue Exception => boom
    puts boom
    flash[:notice] = t(:error_proposal_loading)
    redirect_to proposals_path
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
    
    begin
      Proposal.transaction do
        @proposal = Proposal.new(params[:proposal])
        @proposal.proposal_state_id = PROP_VALUT
        psaved = @proposal.save!
        proposalparams = {
              :proposal_id => @proposal.id,
              :user_id => current_user.id
        }
        
        proposalpresentation = ProposalPresentation.new(proposalparams)
        proposalpresentation.save!
      end
      
      respond_to do |format|
        flash[:notice] = t(:proposal_inserted)
        format.html { redirect_to(proposals_url) }
        format.xml  { render :xml => @proposal, :status => :created, :location => @proposal }        
      end
      
    rescue ActiveRecord::ActiveRecordError => e
      if @proposal.errors[:title]
        @other = Proposal.find_by_title(params[:proposal][:title])
        #@proposal.errors[:title] = "Esiste già un'altra proposta cono questo titolo. <a href=\"#\">Guardala</a>!"          
      end
      respond_to do |format|
        format.html { render :action => "new" }
        format.xml  { render :xml => @proposal.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update
    respond_to do |format|
      if @proposal.update_attributes(params[:proposal])
        flash[:notice] = t(:proposal_updated)
        format.html { redirect_to  @proposal }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @proposal.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def set_votation_date
     if @proposal.proposal_state_id != PROP_WAIT_DATE
      flash[:error] = t(:error_proposal_not_waiting_date)
      respond_to do |format|
        format.html {
          redirect_to proposal_path(params[:id])
        }
        format.js { render :update do |page|
            page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
        end                  
        }
      end
    else    
      @proposal.vote_period_id = params[:proposal][:vote_period_id]
      @proposal.proposal_state_id = PROP_WAIT
      @proposal.save
      flash[:notice] = t(:proposal_date_selected)
      respond_to do |format|
        format.js do
          render :update do |page|
            page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
          end
        end
      end
    end
  end
  
  
  def destroy
    presentations = ProposalPresentation.find_all_by_proposal_id(@proposal.id)
    presentations.each { |presentation| presentation.destroy }
    @proposal.destroy
    
    respond_to do |format|
      format.html {
        flash[:notice] = t(:proposal_deleted)
        redirect_to(proposals_url) 
      }
      format.xml  { head :ok }
    end
  end
  
  def rankup 
    rank 1
  end
  
  def rankdown
    rank 3
  end
  
  
  protected
  
  #valuta una proposta
  def rank(rank_type)
    if @my_ranking            #se essite già una mia valutazione, aggiornala
      @ranking = @my_ranking
    else                      #altrimenti creane una nuova
      @ranking = ProposalRanking.new
      @ranking.user_id = current_user.id
      @ranking.proposal_id = params[:id]
    end
    @ranking.ranking_type_id = rank_type  #setta il tipo di valutazione
    
    ProposalRanking.transaction do
      
      saved = @ranking.save
      
      valutations = @proposal.valutations
      rank = @proposal.rank
      if (valutations > PROP_VOTES_TO_PROMOTE)        #se ho raggiunto il numero di voti sufficiente a cambiare lo stato verifica il ranking
        if (rank >= PROP_RANKING_TO_PROMOTE)
          @proposal.proposal_state_id = PROP_WAIT_DATE  #metti la proposta in attesa di una data per la votazione
        elsif (rank <= PROP_RANKING_TO_DEGRADE) 
          @proposal.proposal_state_id = PROP_RESP
        end        
      end
      @proposal.save
      
      respond_to do |format|
        if saved
          load_my_vote
          flash[:notice] = t(:proposal_rank_registered)
          format.html 
          format.js { render :update do |page|                    
              page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
              page.replace_html "rankingpanelcontainer", :partial => 'proposals/ranking_panel', :locals => {:flash => flash}                     
            end                     
          }
        else        
          flash[:notice] = t(:error_on_proposal_rank)
          format.html 
          format.js { render :update do |page|
              page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
            end
          }       
        end
      end
      
    end #transaction
  rescue Exception => e
    flash[:notice] = t(:error_on_proposal_rank)
    respond_to do |format|
      format.html 
      format.js { render :update do |page|
          page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
          page.replace_html "rankingpanelcontainer", :partial => 'proposals/ranking_panel', :locals => {:flash => flash}                     
          
        end
      }       
    end
  end
  
  
  def load_proposal
    @proposal = Proposal.find(params[:id])
    load_my_vote
  end
  
  def load_my_vote
    if (@proposal.proposal_state_id != PROP_VALUT)
      @can_vote_again = 0
    else
      ranking = ProposalRanking.find_by_user_id_and_proposal_id(current_user.id,@proposal.id) if current_user
      @my_vote = ranking.ranking_type_id if ranking
      if @my_vote
        if ranking.updated_at < @proposal.updated_at
          flash.now[:notice] = "La proposta è stata aggiornata da quando l'hai votata. Puoi cambiare il tuo voto se vuoi!"
          @can_vote_again = 1
        else
          @can_vote_again = 0
        end
      else
        @can_vote_again = 1
      end
    end
  end
  #questo metodo permette di verificare che l'utente collegato 
  #sia l'autore della proposta il cui id è presente nei parametri
  def check_author
    if !is_proprietary? @proposal and !is_admin?
      flash[:notice] = t(:error_proposal_not_your)
      redirect_to proposals_path
    end
  end
  
  
  def valutation_state_required
     if @proposal.proposal_state_id != PROP_VALUT
      flash[:error] = t(:error_proposal_not_valutating)
      respond_to do |format|
        format.html {
          redirect_to :back
        }
        format.js { render :update do |page|
            page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
            page.replace_html "rankingpanelcontainer", :partial => 'proposals/ranking_panel', :locals => {:flash => flash}          
          end                  
        }
      end
    end
  end
  
  #viene eseguita prima della registrazione della valutazione dell'utente.
  #se un utente ha già valutato la proposta ed essa non è più stata modifica successivamente
  #allora l'operazione viene annullata e viene mostrato un messagio di errore.
  #la stessa cosa avviene se la proposta non è in fase di valutazione
  def can_valutate   
    @my_ranking = ProposalRanking.find_by_user_id_and_proposal_id(current_user.id,params[:id])
    @my_vote = @my_ranking.ranking_type_id if @my_ranking
    if @my_vote && @my_ranking.updated_at > @proposal.updated_at
      flash[:error] = t(:error_proposal_already_ranked)
      respond_to do |format|
        format.html {
          redirect_to proposal_path(params[:id])
        }
        format.js { render :update do |page|
            page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
            page.replace_html "rankingpanelcontainer", :partial => 'proposals/ranking_panel', :locals => {:flash => flash}          
          end                  
        }
      end
    else
      return true
    end
  end
end
