#encoding: utf-8
class ProposalsController < ApplicationController
  include NotificationHelper
  
  #load_and_authorize_resource
  #carica la proposta
  before_filter :load_proposal, :except => [:index, :index_accepted, :endless_index, :new, :create, :index_by_category]
  
###SICUREZZA###
  
  #l'utente deve aver fatto login
  before_filter :authenticate_user!, :except => [:index,:index_accepted, :endless_index, :show]
  
  #l'utente deve essere autore della proposta
  before_filter :check_author, :only => [:edit, :update, :destroy, :set_votation_date]
  
  #la proposta deve essere in stato 'IN VALUTAZIONE'
  before_filter :valutation_state_required, :only => [:edit,:update,:rankup,:rankdown,:destroy]
  #l'utente deve poter valutare la proposta
  before_filter :can_valutate, :only => [:rankup,:rankdown]
    
  def index
    query_index     
    respond_to do |format|     
      #format.js 
      format.html # index.html.erb      
    end
  end
  
  def endless_index
    query_index
    respond_to do |format|     
      format.js             
    end
  end
    
  def index_accepted
    #se è stata scelta una categoria, filtra per essa
    if (params[:category])
        @category = ProposalCategory.find_by_id(params[:category])
        @proposals = Proposal.accepted.find(:all,:conditions => ["proposal_category_id = ?",params[:category]],:order => "created_at desc")
    else #altrimenti ordina per data di creazione
        @proposals = Proposal.accepted.includes(:users).find(:all, :order => "created_at desc")
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
    
 # rescue Exception => boom
 #   puts boom
 #   flash[:notice] = t(:error_proposal_loading)
 #   redirect_to proposals_path
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
        prparams = params[:proposal]
        @proposal = Proposal.new(prparams)
        @proposal.proposal_state_id = PROP_VALUT
        @proposal.rank = 0
        psaved = @proposal.save!
        proposalparams = {
              :proposal_id => @proposal.id,
              :user_id => current_user.id
        }
        
        proposalpresentation = ProposalPresentation.new(proposalparams)
        proposalpresentation.save!
        
        borders = prparams[:interest_borders_tkn]
        update_borders(borders)
      end
      
      respond_to do |format|
        flash[:notice] = t(:proposal_inserted)
        format.html { redirect_to(proposals_url) }              
      end
      
    rescue ActiveRecord::ActiveRecordError => e
      if @proposal.errors[:title]
        @other = Proposal.find_by_title(params[:proposal][:title])
        #@proposal.errors[:title] = "Esiste già un'altra proposta cono questo titolo. <a href=\"#\">Guardala</a>!"          
      end
      respond_to do |format|
        format.html { render :action => "new" }
      end
    end
  end
  
  def update
    begin
      Proposal.transaction do
        prparams = params[:proposal]
        borders = prparams[:interest_borders_tkn]
        #cancella i vecchi confini di interesse
        @proposal.proposal_borders.each do |border|
          border.destroy
        end
      
        update_borders(borders)
        @proposal.update_attributes(params[:proposal])
        notify_proposal_has_been_updated(@proposal)
      end
      
      respond_to do |format|
        flash[:notice] = t(:proposal_updated)
        format.html { redirect_to  @proposal }
      end
      
    rescue ActiveRecord::ActiveRecordError => e
      respond_to do |format|
        format.html { render :action => "edit" }
      end
    end
  end
  
  def set_votation_date
     if @proposal.proposal_state_id != PROP_WAIT_DATE
      flash[:error] = t(:error_proposal_not_waiting_date)
      respond_to do |format|
        format.js { render :update do |page|
            page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
        end                  
        }
        format.html {
          redirect_to proposal_path(params[:id])
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
  
  
  def statistics
     respond_to do |format|
      format.html 
      format.js do
          render :update do |page|
              page.replace_html "statistics_panel", :partial => 'statistics', :locals => {:proposal => @proposal}
          end
      end
    end
  end
  
  
  protected
  
  #utilizzato sia da index che da index_endless
  #dividendo i due metodi evito il problema di integrazione con
  #facebook quando si inserisce un link al sito.
  def query_index
    order = ""
    if (params[:view] == ORDER_BY_RANK)
      order << " rank desc, created_at desc"
    elsif (params[:view] == ORDER_BY_VOTES)
      order << " valutations desc, created_at desc"
    else
      order << "created_at desc"  
    end
    
    #se è stata scelta una categoria, filtra per essa
    if (params[:category])
        @category = ProposalCategory.find_by_id(params[:category])
        @proposals = Proposal.current.paginate(:page => params[:page], :per_page => PROPOSALS_PER_PAGE, :conditions => ["proposal_category_id = ?",params[:category]],:order => order)
    else #altrimenti ordina per data di creazione
        @proposals = Proposal.current.includes(:users).paginate(:page => params[:page], :per_page => PROPOSALS_PER_PAGE, :order => order)
    end
  end
  
  def update_borders(borders)
     #confini di interesse, scorrili
    borders.split(',').each do |border| #l'identificativo è nella forma 'X-id'
      ftype = border[0,1] #tipologia (primo carattere)
      fid = border[2..-1]  #chiave primaria (dal terzo all'ultimo carattere)
      found = InterestBorder.table_element(border)
      
   
      if (found)  #se ho trovato qualcosa, allora l'identificativo è corretto e posso procedere alla creazione del confine di interesse
        interest_b = InterestBorder.find_or_create_by_ftype_and_foreign_id(ftype,fid)
        puts "New Record!" if (interest_b.new_record?)
        i = @proposal.proposal_borders.build({:interest_border_id => interest_b.id})
      end
    end
  end
  
  #valuta una proposta
  def rank(rank_type)
    if @my_ranking            #se essite già una mia valutazione, aggiornala
      @ranking = @my_ranking
    else                      #altrimenti creane una nuova
      @ranking = ProposalRanking.new
      @ranking.user_id = current_user.id
      @ranking.proposal_id = params[:id]
      notify_user_valutate_proposal(@ranking)
    end
    @ranking.ranking_type_id = rank_type  #setta il tipo di valutazione
    
    ProposalRanking.transaction do
      
      saved = @ranking.save
      @proposal.reload
      valutations = @proposal.valutations
      rank = @proposal.rank
      if (valutations > PROP_VOTES_TO_PROMOTE)        #se ho raggiunto il numero di voti sufficiente a cambiare lo stato verifica il ranking
        if (rank >= PROP_RANKING_TO_PROMOTE)
          @proposal.proposal_state_id = PROP_WAIT_DATE  #metti la proposta in attesa di una data per la votazione
        elsif (rank <= PROP_RANKING_TO_DEGRADE) 
          @proposal.proposal_state_id = PROP_RESP
        end        
        @proposal.save
        @proposal.reload
      end
      
      respond_to do |format|
        if saved
          load_my_vote
          flash[:notice] = t(:proposal_rank_registered)
          format.js { render :update do |page|                    
              page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
              page.replace_html "rankingpanelcontainer", :partial => 'proposals/ranking_panel', :locals => {:flash => flash}                     
            end                     
          }
          format.html 
        else        
          flash[:notice] = t(:error_on_proposal_rank)
          format.js { render :update do |page|
              page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
            end
          }       
          format.html 
        end
      end
      
    end #transaction
  rescue Exception => e
#    log_error(e)
    flash[:notice] = t(:error_on_proposal_rank)
    respond_to do |format|
      format.js { render :update do |page|
          page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
          page.replace_html "rankingpanelcontainer", :partial => 'proposals/ranking_panel', :locals => {:flash => flash}                     
          
        end
      }       
      format.html 
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
          flash.now[:notice] = t('info.proposal.can_change_valutation')
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
        format.js { render :update do |page|
            page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
            page.replace_html "rankingpanelcontainer", :partial => 'proposals/ranking_panel', :locals => {:flash => flash}          
          end                  
        }
        format.html {
          redirect_to :back
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
        format.js { render :update do |page|
            page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
            page.replace_html "rankingpanelcontainer", :partial => 'proposals/ranking_panel', :locals => {:flash => flash}          
          end                  
        }
        format.html {
          redirect_to proposal_path(params[:id])
        }
      end
    else
      return true
    end
  end
end
