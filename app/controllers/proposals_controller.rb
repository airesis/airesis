#encoding: utf-8
class ProposalsController < ApplicationController
  include NotificationHelper, StepHelper, ProposalsModule
  
  #load_and_authorize_resource
  
  
  #carica il gruppo
  before_filter :load_group
  
  layout :choose_layout
  #carica la proposta
  before_filter :load_proposal, :except => [:index, :index_accepted, :tab_list, :endless_index, :new, :create, :index_by_category, :similar]
  
  ###SICUREZZA###
  
  #l'utente deve aver fatto login
  before_filter :authenticate_user!, :except => [:index,:index_accepted, :tab_list, :endless_index, :show]
  
  #l'utente deve essere autore della proposta
  before_filter :check_author, :only => [:edit, :update, :destroy, :set_votation_date, :add_authors]
  
  #la proposta deve essere in stato 'IN VALUTAZIONE'
  before_filter :valutation_state_required, :only => [:edit,:update,:rankup,:rankdown,:destroy, :available_author, :add_authors]
  
  #l'utente deve poter valutare la proposta
  before_filter :can_valutate, :only => [:rankup,:rankdown]
  
  #TODO se la proposta è interna ad un gruppo, l'utente deve avere i permessi per visualizzare,inserire o partecipare alla proposta
    
  def index    
    if (params[:category])
      @category = ProposalCategory.find_by_id(params[:category])
      #@count_base = @category.proposals
    end
    @count_base = Proposal.in_category(params[:category])

    if (params[:group_id])
      @count_base = @count_base.in_group(@group.id)
    	#@count_base = @count_base.includes([:proposal_supports,:group_proposals])
      #.where("((proposal_supports.group_id = ? and proposals.private = 'f') or (group_proposals.group_id = ? and proposals.private = 't'))",params[:group_id],params[:group_id])
    
      if !(can? :view_proposal, @group)
        flash.now[:notice] = "Non hai i permessi per visualizzare le proposte private. Contatta gli amministratori del gruppo."    
      end 
   else
      @count_base = @count_base.public
    end
   

    @in_valutation_count = @count_base.in_valutation.count
    @in_votation_count = @count_base.in_votation.count
    @accepted_count = @count_base.accepted.count
    @revision_count = @count_base.revision.count
    
    respond_to do |format|     
      #format.js 
      format.html # index.html.erb      
    end
  end
  
    
  def tab_list
    query_index             
    respond_to do |format|     
      format.html {
        if (params[:replace])
          render :update do |page|
            #TODO far dipendere l'id della tab dallo stato della proposta non è buona cosa ma mi permette di non sbattermi per trovare una soluzione
            #accrocchio
            #render :partial => 'replace_tab_list', :locals => {:proposals => @proposals} 
            page.replace_html params[:replace_id], :partial => 'tab_list', :locals => {:proposals => @proposals}
          end
        else          
          render :partial => 'tab_list', :locals => {:proposals => @proposals}
        end
      }# index.html.erb      
    end
  end
  
  def endless_index
    query_index
    respond_to do |format|     
      format.js             
    end
  end
   
  def show
    @step = get_next_step(current_user) if current_user
    if (@proposal.private && @group && !(can? :view_proposal, @group)) 
      respond_to do |format|
        flash[:error] = "Non disponi dei permessi per visualizzare questa proposta"        
        format.html { 
          redirect_to group_proposals_path(@group)
        }              
      end
    else        
      if (@proposal.private && @group && !(can? :partecipate_proposal, @group))       
        flash[:error] = "Non disponi dei permessi per partecipare attivamente a questa proposta. Contatta gli amministratori del gruppo"
      end
      author_id = ProposalPresentation.find_by_proposal_id(params[:id]).user_id
      @author_name = User.find(author_id).name
      
      @proposal_comments = @proposal.contributes.includes(:user => :proposal_nicknames).paginate(:page => params[:page],:per_page => COMMENTS_PER_PAGE, :order => 'created_at DESC')
      @my_nickname = current_user.proposal_nicknames.find_by_proposal_id(@proposal.id) if current_user
      respond_to do |format|
        #format.js
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
 # rescue Exception => boom
 #   puts boom
 #   flash[:notice] = t(:error_proposal_loading)
 #   redirect_to proposals_path
  end
  
  def new
    @step = get_next_step(current_user)
    @proposal = Proposal.new
    
    if (params[:group_id])
      @group = Group.find_by_id(params[:group_id])
      @proposal.interest_borders << @group.interest_border
      @proposal.private = true
      @proposal.presentation_groups << @group
      @proposal.anonima = @group.default_anonima  
      @change_advanced_options = @group.change_advanced_options
    else
      @proposal.quorum_id = Quorum::STANDARD
      @proposal.anonima = DEFAULT_ANONIMA
      @change_advanced_options = DEFAULT_CHANGE_ADVANCED_OPTIONS
    end
    
    respond_to do |format|
      format.js
      format.html # new.html.erb
      format.xml  { render :xml => @proposal }
    end
  end
  
  def edit    
  end
  
  def create
    begin
      @saved = false
      Proposal.transaction do
        prparams = params[:proposal]

        quorum = Quorum.find(prparams[:quorum_id])
        copy = quorum.dup
        starttime = Time.now
        
        copy.started_at = starttime
        if (quorum.minutes)
          endtime = starttime + quorum.minutes.minutes
          copy.ends_at = endtime
        end 
        #se il numero di valutazioni è definito
        if (quorum.percentage)
          if @group #calcolo il numero in base ai partecipanti
            copy.valutations = ((quorum.percentage.to_f * @group.count_voter_partecipants.to_f) / 100).floor
          else  #calcolo il numero in base agli utenti del portale (il 10%)
            copy.valutations = ((quorum.percentage.to_f * User.all.count.to_f) / 1000).floor
          end
          #deve essere almeno 1!
          copy.valutations = [copy.valutations,1].max
        end
	      copy.public = false
        copy.save!

        @proposal = Proposal.new(prparams)
        #per sicurezza reimposto questi parametri per far si che i cattivi hacker non cambino le impostazioni se non possono
        if (@group)          
          @proposal.anonima = @group.default_anonima unless (@group.change_advanced_options)  
        else
          @proposal.anonima = DEFAULT_ANONIMA          
        end
        @proposal.quorum_id = copy.id
        
        @proposal.proposal_state_id = PROP_VALUT
        @proposal.rank = 0
        borders = prparams[:interest_borders_tkn]
        update_borders(borders)
        @proposal.save!
        
        proposalparams = {
              :proposal_id => @proposal.id,
              :user_id => current_user.id
        }
        
        proposalpresentation = ProposalPresentation.new(proposalparams)
        proposalpresentation.save!
        generate_nickname(current_user,@proposal) 
    	
        #fai partire il timer per far scadere la proposta
        if (quorum.minutes)
          Resque.enqueue_at(copy.ends_at, ProposalsWorker, {:action => ProposalsWorker::ENDTIME, :proposal_id => @proposal.id})
        end

        notify_proposal_has_been_created(@group,@proposal) if @group
      end
      @saved = true
      
      respond_to do |format|
        flash[:notice] = t(:proposal_inserted)
        format.js
        format.html { 
         if request.env['HTTP_REFERER']["back=home"]
          redirect_to home_url
         else 
          redirect_to :back
         end 
        }              
      end
      
    rescue ActiveRecord::ActiveRecordError => e
      log_error(e)
      if @proposal.errors[:title]
        @other = Proposal.find_by_title(params[:proposal][:title])
        #@proposal.errors[:title] = "Esiste già un'altra proposta cono questo titolo. <a href=\"#\">Guardala</a>!"          
      end
      respond_to do |format|
        format.js
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
        @proposal.update_user_id = current_user.id
        @proposal.update_attributes(params[:proposal])
        notify_proposal_has_been_updated(@proposal)
      end
      
      respond_to do |format|
        flash[:notice] = t(:proposal_updated)
        format.html {
          if params[:from_group]
            @group = Group.find_by_id(params[:from_group])
            redirect_to [@group,@proposal]
          else
            redirect_to @proposal
          end 
        }
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
      @proposal.save!
      notify_proposal_waiting_for_date(@proposal)
      flash[:notice] = t(:proposal_date_selected)
      respond_to do |format|
        format.js do
          render :update do |page|
            page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
          end
        end
        format.html { redirect_to proposal_path(params[:id]) }
      end
    end
    
    rescue Exception => boom
      flash[:error] = t(:error_updating)
      redirect_to :back
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
  
  #restituisce una lista di tutte le proposte simili a quella
  #passata come parametro
  #se è indicato un group_id cerca solo tra quelle interne a quel gruppo
  def similar
    tags = params[:tags].downcase.gsub('.','').gsub("'","").split(",").map{|t| "'#{t.strip}'"}.join(",").html_safe
    if tags.empty? 
      tags = "''"
    end  
    sql_q ="SELECT p.id, p.proposal_state_id, p.proposal_category_id, p.title, p.content, 
p.created_at, p.updated_at, p.valutations, p.vote_period_id, p.proposal_comments_count, 
p.rank, p.problem, p.subtitle, p.problems, p.objectives, p.show_comment_authors, COUNT(*) AS closeness
                                      FROM proposal_tags pt join proposals p on pt.proposal_id = p.id"
    if params[:group_id]
      sql_q += " join group_proposals gp on gp.proposal_id = p.id "
    end                                   
    sql_q +=                              " WHERE pt.tag_id IN (SELECT pti.id
                                              FROM tags pti 
                                              WHERE pti.text in (#{tags}))"
    params[:group_id] ?
        sql_q += " AND p.private = true AND gp.group_id = " + @group.id.to_s :
        sql_q += " AND p.private = false "
    sql_q +=" GROUP BY p.id, p.proposal_state_id, p.proposal_category_id, p.title, p.content, 
p.created_at, p.updated_at, p.valutations, p.vote_period_id, p.proposal_comments_count, 
p.rank, p.problem, p.subtitle, p.problems, p.objectives, p.show_comment_authors
                                      ORDER BY closeness DESC"                                           
    @similars  = Proposal.find_by_sql(sql_q)
                                                  
    respond_to do |format|
      format.js 
      format.html 
    end
  end
  
  #questo metodo permette all'utente corrente di mettersi a disposizione per redigere la sintesi della proposta
  def available_author
    @proposal.available_user_authors << current_user
    @proposal.save
    flash[:notice] = "Ti sei reso disponibile per redigere la sintesi della proposta!"
    respond_to do |format|
      format.js { render :update do |page|
                    page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
                    page.replace_html "available_author", :partial => 'proposals/available_author'
                  end                   
      }        
    end
  end
  
  #restituisce la lista degli utenti disponibili a redigere la sintesi della proposta
  def available_authors_list
    @available_authors = @proposal.available_user_authors
    respond_to do |format|
      format.js
    end
  end
  
  #aggiunge alcuni degli utenti che si sono resi disponibili a redigere la sintesi
  #agli autori della proposta
  def add_authors
    available_ids = params['user_ids']
    
    Proposal.transaction do    
      users = @proposal.available_user_authors.all(:conditions => ['users.id in (?)', available_ids.map{|id| id.to_i}]) rescue []
      @proposal.available_user_authors -= users
      @proposal.users << users
      @proposal.save
    end
  
    flash[:notice] = "Nuovi redattori aggiunti correttamente!"
    respond_to do |format|
      format.js { render :update do |page|
                    page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
                    page.replace_html "authors_list", :partial => 'proposals/authors_list_panel'     
                    page << "$('#available_authors_list_container').dialog('close');"               
                  end                   
      }        
    end
    
  rescue Exception => e
    flash[:error] = "Errore durante l'aggiunta dei nuovi autori"
    respond_to do |format|
      format.js { render :update do |page|
          page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
          page << "$('#available_authors_list_container').dialog('close');"                               
        end
      }              
    end
  end
  
  
  protected
  
  def choose_layout
    @group ? "groups" : "open_space"
  end 
   
   
  #query per la ricerca delle proposte 
  def query_index
    order = ""
    if (params[:view] == ORDER_BY_RANK)
      order << " proposals.rank desc, proposals.created_at desc"
    elsif (params[:view] == ORDER_BY_VOTES)
      order << " proposals.valutations desc, proposals.created_at desc"
    else
      order << "proposals.created_at desc"  
    end
    
    conditions = "1 = 1"
    
    if (params[:state] == VOTATION_STATE)
      startlist = Proposal.in_votation   
      @replace_id = t("pages.proposals.index.voting").gsub(' ','_')
    elsif (params[:state] == ACCEPTED_STATE)
      startlist = Proposal.accepted
      @replace_id = t("pages.proposals.index.accepted").gsub(' ','_')
    elsif (params[:state] == REVISION_STATE)
      startlist = Proposal.revision
      @replace_id = t("pages.proposals.index.revision").gsub(' ','_')
    else
     startlist = Proposal.in_valutation
     @replace_id = t("pages.proposals.index.debate").gsub(' ','_')
    end
    
    #se è stata scelta una categoria, filtra per essa
    #if (params[:category])
    #  @category = ProposalCategory.find_by_id(params[:category])
    #  conditions += " and proposal_category_id = #{params[:category]}"
    #end
    
    startlist = startlist.in_category(params[:category])

    #applica il filtro per il gruppo
    if params[:group_id]
      #se l'utente è connesso e dispone dei permessi per visualizzare le proposte interne mostragliele, altrimenti mostragli un emssaggio che lo avverte
      #che non dispone dei permessi per visualizzare quelle interne
      conditions += " and ((proposal_supports.group_id = " + @group.id.to_s + " and proposals.private = 'f')"
      if can? :view_proposal, @group
        conditions += " or (group_proposals.group_id = " + @group.id.to_s + " and proposals.private = 't')"
      end
      conditions += ")"
      #startlist = startlist.private
    else
      startlist = startlist.public
    end
    
    @proposals = startlist.includes([:proposal_supports,:group_proposals]).paginate(:page => params[:page], :per_page => PROPOSALS_PER_PAGE, :conditions => conditions, :order => order)
  end
  
  def update_borders(borders)
     #confini di interesse, scorrili
    borders.split(',').each do |border| #l'identificativo è nella forma 'X-id'
      ftype = border[0,1] #tipologia (primo carattere)
      fid = border[2..-1]  #chiave primaria (dal terzo all'ultimo carattere)
      found = InterestBorder.table_element(border)
      
   
      if (found)  #se ho trovato qualcosa, allora l'identificativo è corretto e posso procedere alla creazione del confine di interesse
        interest_b = InterestBorder.find_or_create_by_territory_type_and_territory_id(InterestBorder::I_TYPE_MAP[ftype],fid)
        puts "New Record!" if (interest_b.new_record?)
        i = @proposal.proposal_borders.build({:interest_border_id => interest_b.id})
      end
    end if borders
  end
  
  #valuta una proposta
  def rank(rank_type)
    if @my_ranking            #se essite già una mia valutazione, aggiornala
      @ranking = @my_ranking
    else                      #altrimenti creane una nuova
      @ranking = ProposalRanking.new
      @ranking.user_id = current_user.id
      @ranking.proposal_id = params[:id]
      notify_user_valutate_proposal(@ranking) #invia notifica per indicare la nuova valutazione
    end
    @ranking.ranking_type_id = rank_type  #setta il tipo di valutazione
    
    ProposalRanking.transaction do
      saved = @ranking.save
      @proposal.reload
      check_phase(@proposal)
           
      respond_to do |format|
        if saved
          load_my_vote
          flash[:notice] = t(:proposal_rank_registered)
          format.js { render :update do |page|                    
              page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
              page.replace_html "rankleftpanel", :partial => 'proposals/rank_left_panel'                     
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
          page.replace_html "rankleftpanel", :partial => 'proposals/rank_left_panel'
          
        end
      }       
      format.html 
    end
  end


  #carica il gruppo di riferimento della proposta
  def load_group
    @group = Group.find(params[:group_id]) if params[:group_id]
  end


  def load_proposal
    @proposal = Proposal.find(params[:id])
    if @proposal.presentation_groups.count > 0 && !params[:group_id]
      redirect_to group_proposal_path(@proposal.presentation_groups.first,@proposal)
    end
    load_my_vote

  end
  
  def load_my_vote
    if @proposal.proposal_state_id != PROP_VALUT
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
  #la stessa cosa avviene se l'utente non dispone dei permessi per partecipare ad una proposta privata del gruppo
  def can_valutate   
    @my_ranking = ProposalRanking.find_by_user_id_and_proposal_id(current_user.id,params[:id])
    @my_vote = @my_ranking.ranking_type_id if @my_ranking
    if ((@my_vote && @my_ranking.updated_at > @proposal.updated_at) ||
        (@proposal.private && @group && !(can? :partecipate_proposal, @group)))
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
