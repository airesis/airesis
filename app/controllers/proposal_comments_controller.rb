class ProposalCommentsController < ApplicationController
 
  
  before_filter :load_proposal
  before_filter :load_proposal_comment, :only => [:show, :edit, :update, :destroy, :adestroy, :rankup, :rankdown]
  
  before_filter :login_required, :only => [ :edit, :update, :destroy, :new, :create ]
  before_filter :check_author, :only => [:edit, :update, :destroy]
  before_filter :already_ranked, :only => [:rankup, :rankdown]
  
  #questo metodo permette di verificare che l'utente collegato sia l'autore del commento
   def check_author
    @proposal_comment = ProposalComment.find(params[:id])
    if ! current_user.is_my_proposal_comment? @proposal_comment.id
      flash[:notice] = 'Non puoi modificare commenti che non siano i tuoi.'
      redirect_to :back
    end
   end
  
  def load_proposal
    @proposal = Proposal.find(params[:proposal_id])
  end  
  
  def load_proposal_comment
    @proposal_comment = @proposal.comments.find(params[:id])
  end  
  
  
  
  def index
    @proposal_comments = ProposalComment.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @proposal_comments }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @proposal_comment }
    end
  end

  def new
    @proposal_comment =  @proposal.comments.build
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @proposal_comment }
    end
  end

 
  def edit

  end

 
  def create
    @proposal_comment =  @proposal.comments.build(params[:proposal_comment])
    @proposal_comment.user_id = current_user.id
    @proposal_comment.request = request

    respond_to do |format|
      if @proposal_comment.save
        flash[:notice] = 'Commento inserito.'
        @proposal_comments = @proposal.comments.paginate(:page => params[:page], :per_page => COMMENTS_PER_PAGE,:order => 'created_at DESC')
        @saved = @proposal_comments.find { |comment| comment.id == @proposal_comment.id }
        @saved.collapsed = true
        format.html { redirect_to @proposal }        
        format.js   { render :update do |page|
                         page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
                        page.replace_html "proposalCommentsContainer", :partial => "proposals/comments"
                        page.replace "proposalNewComment", :partial => 'proposal_comments/proposal_comment', :locals => {:proposal_comment => @proposal.comments.new}
                      end
                    }
        format.xml  { render :xml => @proposal_comment, :status => :created, :location => @proposal_comment }
      else
        format.html 
        format.js   { render :update do |page|
                        page.replace "proposalNewComment", :partial => 'proposal_comments/proposal_comment', :locals => {:proposal_comment => @proposal_comment}
                      end
                    }
        format.xml  { render :xml => @blog_comment.errors, :status => :unprocessable_entity }
        format.xml  { render :xml => @proposal_comment.errors, :status => :unprocessable_entity }
      end
    end
    
  rescue Exception => e
     respond_to do |format|
       flash[:error] = 'Errore durante l''inserimento.'
       format.js   { render :update do |page|
                           page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
                      end}
     end
  end


  def update
    respond_to do |format|
      if @proposal_comment.update_attributes(params[:proposal_comment])
        flash[:notice] = 'Il tuo commento è stato aggiornato con successo.'
        format.html { redirect_to(@proposal) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @proposal_comment.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @proposal_comment.destroy

    respond_to do |format|
      flash[:notice] = 'Commento eliminato.'
      format.html { redirect_to @proposal }
      format.xml  { head :ok }
    end
  end
  
   def adestroy     
    @proposal_comment.logical_delete
    @proposal_comment.destroy
    @proposal_comments = @proposal.comments.paginate(:page => params[:page],:per_page => COMMENTS_PER_PAGE, :order => 'created_at DESC')
    
    respond_to do |format|      
        flash[:notice] = 'Il commento è stato cancellato'
        format.html { redirect_to @proposal }
        format.js   { render :update do |page|
                        page.replace_html "flash_messages_comments", :partial => 'layouts/flash', :locals => {:flash => flash}
                        page.replace_html "proposalCommentsContainer", :partial => "proposals/comments"                                          
                      end
                    }
    end
  end
  
  
   def rankup 
    rank 1
  end
  
  def rankdown
    rank 3
  end
  
  
  protected
  
  
  def rank(rank_type)
    if @my_ranking
      @ranking = @my_ranking
    else
      @ranking = ProposalCommentRanking.new
      @ranking.user_id = current_user.id
      @ranking.proposal_comment_id = params[:id]
    end
    @ranking.ranking_type_id = rank_type
    
    
    respond_to do |format|
      if @ranking.save
        flash[:notice] = t(:proposal_comment_rank_registered)
        format.html { redirect_to @proposal }
        format.js { render :update do |page|                    
                    page.replace_html "flash_messages_comment_#{params[:id]}", :partial => 'layouts/flash', :locals => {:flash => flash}
                    page.replace_html "rankingpanelcontainer#{params[:id]}", :partial => 'proposal_comments/ranking_panel', :locals => {:comment => @proposal_comment}
                    end
                  }
      else        
        flash[:notice] = t(:error_on_proposal_comment_rank)
        format.html { redirect_to @proposal }
        format.js { render :update do |page|
                    page.replace_html "flash_messages_comment_#{params[:id]}", :partial => 'layouts/flash', :locals => {:flash => flash}
                    end
                  }       
      end
    end
  end
  
  #viene eseguita prima della registrazione della valutazione dell'utente.
  #se un utente ha già valutato la proposta ed essa non è più stata modifica successivamente
  #allora l'operazione viene annullata e viene mostrato un messagio di errore.
  def already_ranked
    my_ranking = ProposalCommentRanking.find_by_user_id_and_proposal_comment_id(current_user.id,params[:id])
    my_rank = my_ranking.ranking_type_id if my_ranking
    if my_rank && my_ranking.updated_at > @proposal_comment.updated_at
      flash[:notice] = t(:error_proposal_comment_already_ranked)
      respond_to do |format|     
      format.html {
        redirect_to proposal_path(params[:proposal_id])
       }
      format.js { render :update do |page|
                     page.replace_html "flash_messages_comment_#{params[:id]}", :partial => 'layouts/flash', :locals => {:flash => flash}
                  end                  
                  }
      end
    else
      return true
    end
  end
  
  
end
