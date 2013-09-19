#encoding: utf-8
class ProposalsController < ApplicationController
  include NotificationHelper, StepHelper, ProposalsModule, GroupsHelper

  #load_and_authorize_resource


  #carica il gruppo
  before_filter :load_group
  before_filter :load_group_area

  layout :choose_layout
  #carica la proposta
  before_filter :load_proposal, :only => [:vote_results]
  before_filter :load_proposal_and_group, :except => [:search, :index, :tab_list, :endless_index, :new, :create, :index_by_category, :similar, :vote_results]

  ###SICUREZZA###

  #l'utente deve aver fatto login
  before_filter :authenticate_user!, :except => [:index, :tab_list, :endless_index, :show]

  #l'utente deve essere autore della proposta
  before_filter :check_author, :only => [:set_votation_date, :add_authors]

  #la proposta deve essere in stato 'IN VALUTAZIONE'
  before_filter :valutation_state_required, :only => [:rankup, :rankdown, :available_author, :add_authors]

  #la proposta deve essere in stato 'VOTATA'
  before_filter :voted_state_required, :only => [:vote_results]

  #l'utente deve poter visualizzare la proposta
  before_filter :can_view, :only => [:vote_results]

  #l'utente deve poter valutare la proposta
  before_filter :can_valutate, :only => [:rankup, :rankdown]


  before_filter :check_page_alerts, only: :show

  def search
    authorize! :view_proposal, @group

    my_areas_ids = current_user.scoped_areas(@group.id, GroupAction::PROPOSAL_VIEW).pluck('group_areas.id')

    #params[:group_id] = @group.id
    @search = Proposal.search(:include => [:category, :quorum, {:users => [:image]}, :vote_period]) do
      fulltext params[:search], :minimum_match => params[:or]
      all_of do
        any_of do
          with(:presentation_group_ids, params[:group_id])
          with(:group_ids, params[:group_id])
        end
        any_of do
          with(:visible_outside, true)
          with(:presentation_area_ids, nil)
          with(:presentation_area_ids, my_areas_ids) unless my_areas_ids.empty?
        end
      end
    end

    #conditions += " and ((proposal_supports.group_id = " + @group.id.to_s + " and proposals.private = 'f')"
    #conditions += "      or (group_proposals.group_id = " + @group.id.to_s + " and proposals.visible_outside = 't')"
    #if can? :view_proposal, @group
    #  conditions += " or (group_proposals.group_id = " + @group.id.to_s + " and proposals.private = 't')"
    #end
    #conditions += ")"

    @proposals = @search.results

  rescue Exception => e
    log_error e
    @proposals = []
    flash[:error] = 'Servizio di indicizzazione non attivo. Spiacenti.'
  end

  def index
    if params[:category]
      @category = ProposalCategory.find_by_id(params[:category])
      #@count_base = @category.proposals
    end
    if params[:group_area_id]
      @group_area = GroupArea.find(params[:group_area_id])
      #@count_base = @category.proposals
    end
    @count_base = Proposal.in_category(params[:category])

    if @group
      authorize! :view_data, @group
      @count_base = @count_base.in_group(@group.id)
      #@count_base = @count_base.includes([:proposal_supports,:group_proposals])
      #.where("((proposal_supports.group_id = ? and proposals.private = 'f') or (group_proposals.group_id = ? and proposals.private = 't'))",params[:group_id],params[:group_id])

      unless can? :view_proposal, @group
        flash.now[:warn] = "Non hai i permessi per visualizzare le proposte private. Contatta gli amministratori del gruppo."
      end

      if params[:group_area_id]
        unless can? :view_proposal, @group_area
          flash.now[:warn] = "Non hai i permessi per visualizzare le proposte private. Contatta gli amministratori del gruppo."
        end

        @count_base = @count_base.in_group_area(@group_area.id)
      else
        if current_user
          @count_base = @count_base.joins('left join area_proposals on proposals.id = area_proposals.proposal_id').where("area_proposals.group_area_id is null or (area_proposals.group_area_id in (#{current_user.scoped_areas(@group, GroupAction::PROPOSAL_VIEW).select('group_areas.id').to_sql})  or proposals.visible_outside = 't')")
        end
      end
      @count_base = @count_base.where("proposals.private = 'f' or (proposals.private = 't' and proposals.visible_outside = 't')") unless current_user
    else
      @count_base = @count_base.public
    end


    @in_valutation_count = @count_base.in_valutation.count
    @in_votation_count = @count_base.in_votation.count
    @accepted_count = @count_base.voted.count
    @revision_count = @count_base.revision.count

    respond_to do |format| 
      format.html # index.html.erb
      format.json
    end
  end

  #list all proposals in a state
  def tab_list
    query_index
    respond_to do |format|
      format.html {
        if params[:replace]
          render :update do |page|         
            page.replace_html params[:replace_id], :partial => 'tab_list', :locals => {:proposals => @proposals}
          end
        else
          render :partial => 'tab_list', :locals => {:proposals => @proposals}
        end
      }
      format.json
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
    if @proposal.private && @group #la proposta è interna ad un gruppo
      if @proposal.visible_outside #se è visibile dall'esterno mostra solo un messaggio
        if !current_user
          flash[:info] = t('info.proposal.ask_participation')
        elsif !(can? :partecipate, @proposal) && @proposal.in_valutation?
          flash[:info] = t('error.proposals.participate')
        end
      else #se è bloccata alla visione di utenti esterni
        if !current_user #se l'utente non è loggato richiedi l'autenticazione
          authenticate_user!
        elsif !(can? :read, @proposal) #se è loggato ma non ha i permessi caccialo fuori
          respond_to do |format|
            flash[:error] = t('error.proposals.view_proposal')
            format.html {
              redirect_to group_proposals_path(@group)
            }
            format.json {
              render :json => {:error => flash[:error]}, :status => 401
              return
            }
          end
        end
        if !(can? :partecipate, @proposal) && @proposal.in_valutation?
          flash[:info] = t('error.proposals.participate')
        end
      end
    end

    flash[:info] = t('info.proposal.public_visible') if @proposal.visible_outside

    @my_nickname = current_user.proposal_nicknames.find_by_proposal_id(@proposal.id) if current_user
    @blocked_alerts = BlockedProposalAlert.find_by_user_id_and_proposal_id(current_user.id, @proposal.id) if current_user

    respond_to do |format|
      #format.js
      format.html {
        if @proposal.proposal_state_id == ProposalState::WAIT_DATE.to_s
          flash.now[:info] = t('info.proposal.waiting_date')
        elsif @proposal.proposal_state_id == ProposalState::VOTING.to_s
          flash.now[:info] = t('info.proposal.voting')
        end
      }
      format.json
      format.pdf {
        if @proposal.voted?
          render :pdf => 'show.pdf.erb',
                 :show_as_html => params[:debug].present?
        else
          flash[:error] = "E' possibile esportare in pdf solo le proposte terminate"
          redirect_to @proposal, format: 'html'
        end
      }
    end
  end

  def new
    begin
      if LIMIT_PROPOSALS
        max = current_user.proposals.maximum(:created_at) || Time.now - (PROPOSALS_TIME_LIMIT + 1.seconds)
        elapsed = Time.now - max
        if elapsed < PROPOSALS_TIME_LIMIT
          raise Exception
        end
      end

      @step = get_next_step(current_user)
      @proposal = Proposal.new

      if params[:group_id]
        @group = Group.find_by_id(params[:group_id])
        @proposal.interest_borders << @group.interest_border
        @proposal.private = true
        @proposal.presentation_groups << @group
        @proposal.anonima = @group.default_anonima
        @proposal.visible_outside = @group.default_visible_outside
        @change_advanced_options = @group.change_advanced_options

        if params[:group_area_id]
          @proposal.group_area_id = params[:group_area_id]
        end

      else
        @proposal.quorum_id = Quorum::STANDARD
        @proposal.anonima = DEFAULT_ANONIMA
        @proposal.visible_outside = true
        @change_advanced_options = DEFAULT_CHANGE_ADVANCED_OPTIONS
      end

      @proposal.proposal_category_id = params[:category]

      send(params[:proposal_type_id].downcase + '_new', @proposal)
      @proposal.proposal_type = ProposalType.find_by_name(params[:proposal_type_id])
      @proposal.proposal_votation_type_id = ProposalVotationType::STANDARD

      @title = ''
      @title += t('pages.proposals.new.title_group', name: @group.name)+ ' ' if @group
      @title += ProposalType.find_by_name(params[:proposal_type_id]).description

      respond_to do |format|
        format.js
        format.html
        format.xml { render :xml => @proposal }
      end
    rescue Exception => e
      respond_to do |format|
        format.js { render :update do |page|
          page.alert "Devono passare 2 minuti tra una proposta e l\'altra\nAttendi ancora #{((PROPOSALS_TIME_LIMIT - elapsed)/60).floor} minuti e #{((PROPOSALS_TIME_LIMIT - elapsed)%60).round(0)} secondi."
          page << "$('#create_proposal_container').dialog('destroy');"
        end }
      end
    end
  end

  def edit
    authorize! :update, @proposal
  end

  def create
    begin
      max = current_user.proposals.maximum(:created_at) || Time.now - (PROPOSALS_TIME_LIMIT + 1.seconds)
      raise Exception if LIMIT_PROPOSALS && ((Time.now - max) < PROPOSALS_TIME_LIMIT)
      @group_area = GroupArea.find(params[:proposal][:group_area_id]) if params[:proposal][:group_area_id] && !params[:proposal][:group_area_id].empty?
      @saved = false
      Proposal.transaction do
        prparams = params[:proposal]

        @proposal = Proposal.new(prparams)

        @proposal_type = ProposalType.find_by_id(params[:proposal][:proposal_type_id])
        send(@proposal_type.name.downcase + '_create', @proposal) #execute specific method to build sections

        #per sicurezza reimposto questi parametri per far si che i cattivi hacker non cambino le impostazioni se non possono
        if @group
          @proposal.anonima = @group.default_anonima unless @group.change_advanced_options
          @proposal.visible_outside = @group.default_visible_outside unless @group.change_advanced_options
          @proposal.secret_vote = @group.default_secret_vote unless @group.change_advanced_options
          if @group_area
            raise Exception unless current_user.scoped_areas(@group, GroupAction::PROPOSAL_INSERT).include? @group_area #check user permissions for this group area
            @proposal.presentation_areas << @group_area
          end
        else
          @proposal.anonima = DEFAULT_ANONIMA
          @proposal.visible_outside = true
          @proposal.secret_vote = true
        end

        #il quorum viene utilizzato per le proposte standard
        # if params[:proposal][:proposal_type_id] == ProposalType::STANDARD.to_s
        quorum = assign_quorum(prparams)

        #metto la proposta in valutazione se è standard
        @proposal.proposal_state_id = PROP_VALUT
        @proposal.rank = 0


        #elsif params[:proposal][:proposal_type_id] == ProposalType::POLL.to_s
        #   @proposal.proposal_state_id = ProposalState::WAIT_DATE
        # end


        borders = prparams[:interest_borders_tkn]
        update_borders(borders)


        @proposal.save!

        @proposal.update_attribute(:url, @proposal.private? ? group_proposal_path(@group, @proposal) : proposal_path(@proposal))


        #fai partire il timer per far scadere la proposta
        if quorum.minutes # && params[:proposal][:proposal_type_id] == ProposalType::STANDARD.to_s
          Resque.enqueue_at(@copy.ends_at, ProposalsWorker, {:action => ProposalsWorker::ENDTIME, :proposal_id => @proposal.id})
        end

        proposalparams = {
            :proposal_id => @proposal.id,
            :user_id => current_user.id
        }

        proposalpresentation = ProposalPresentation.new(proposalparams)
        proposalpresentation.save!
        generate_nickname(current_user, @proposal)

        Resque.enqueue_in(1, NotificationProposalCreate, current_user.id, @proposal.id, @group ? @group.id : nil)
      end
      @saved = true

      respond_to do |format|
        flash[:notice] = t('info.proposal.proposal_created')
        format.js {
          render :update do |page|
            if request.env['HTTP_REFERER']["back=home"]
              page.redirect_to home_url
            else
              page.redirect_to @group ? edit_group_proposal_url(@group, @proposal) : edit_proposal_path(@proposal)
            end
          end
        }
        format.html {
          if request.env['HTTP_REFERER']["back=home"]
            redirect_to home_url
          else
            redirect_to @group ? edit_group_proposal_url(@group, @proposal) : edit_proposal_path(@proposal)
          end
        }
      end

    rescue Exception => e
      log_error(e)
      if @proposal.errors[:title]
        @other = Proposal.find_by_title(params[:proposal][:title])
      end
      respond_to do |format|
        format.js {
          render :update do |page|
            page.alert t('error.proposals.creation')
          end
        }
        format.html { render :action => "new" }
      end
    end
  end

  #put back in debate a proposal
  def regenerate
    authorize! :regenerate, @proposal

    @proposal.proposal_state_id = ProposalState::VALUTATION
    @proposal.users << current_user

    quorum = assign_quorum(params[:proposal])
    #fai partire il timer per far scadere la proposta
    if quorum.minutes # && params[:proposal][:proposal_type_id] == ProposalType::STANDARD.to_s
      Resque.enqueue_at(@copy.ends_at, ProposalsWorker, {:action => ProposalsWorker::ENDTIME, :proposal_id => @proposal.id})
    end

    generate_nickname(current_user, @proposal)

    @proposal.save!

    flash[:notice] = t('info.proposal.back_in_debate')

    redirect_to @proposal.private? ? group_proposal_url(@proposal.presentation_groups.first,@proposal) : proposal_url(@proposal)
  end

  def assign_quorum(prparams)
    quorum = Quorum.find(prparams[:quorum_id])
    @copy = quorum.dup
    starttime = Time.now

    @copy.started_at = starttime
    if quorum.minutes
      endtime = starttime + quorum.minutes.minutes
      @copy.ends_at = endtime
    end
    #se il numero di valutazioni è definito
    if quorum.percentage
      if @group #calcolo il numero in base ai partecipanti
        @copy.valutations = ((quorum.percentage.to_f * @group.count_voter_partecipants.to_f) / 100).floor
      else #calcolo il numero in base agli utenti del portale (il 10%)
        @copy.valutations = ((quorum.percentage.to_f * User.count.to_f) / 1000).floor
      end
      #deve essere almeno 1!
      @copy.valutations = [@copy.valutations, 1].max
    end
    @copy.public = false
    @copy.save!
    @proposal.quorum_id = @copy.id
    quorum
  end

  def update
    authorize! :update, @proposal
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

        unless can? :destroy, @proposal
          params[:proposal] = params[:proposal].except(:title, :subtitle, :interest_borders_tkn, :tags_list, :quorum_id, :anonima, :visible_outside, :secret_vote)
        end


        #if params[:proposal][:quorum_id]
        #  Resque.remove_delayed(ProposalsWorker, {:action => ProposalsWorker::ENDTIME, :proposal_id => @proposal.id})

        #  @old_quorum = @proposal.quorum

        #  quorum = assign_quorum(params[:proposal])

        #fai partire il timer per far scadere la proposta
        #  if quorum.minutes && @proposal.proposal_type_id.to_s == ProposalType::STANDARD.to_s
        #    Resque.enqueue_at(@copy.ends_at, ProposalsWorker, {:action => ProposalsWorker::ENDTIME, :proposal_id => @proposal.id})
        #  end
        #  params[:proposal][:quorum_id] = @copy.id

        #end

        @proposal.attributes = params[:proposal]

        if @proposal.title_changed?
          @proposal.url = @proposal.private? ? group_proposal_url(@proposal.presentation_groups.first, @proposal) : proposal_path(@proposal)
        end

        @proposal.save!

        #@old_quorum.destroy if @old_quorum

        notify_proposal_has_been_updated(@proposal, @group)
      end

      respond_to do |format|
        flash[:notice] = t('info.proposal.proposal_updated')
        format.html {
          redirect_to @group ? group_proposal_url(@group, @proposal) : @proposal
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
      flash[:error] = t('error.proposals.proposal_not_waiting_date')
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
      vote_period = Event.find(params[:proposal][:vote_period_id])
      raise Exception unless vote_period.starttime > (Time.now + 5.seconds) #controllo di sicurezza
      @proposal.vote_period_id = params[:proposal][:vote_period_id]
      @proposal.proposal_state_id = PROP_WAIT
      @proposal.save!
      notify_proposal_waiting_for_date(@proposal, @group)
      flash[:notice] = t('info.proposal.date_selected')
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
    flash[:error] = t('error.proposals.updating')
    redirect_to :back
  end


  def destroy
    authorize! :destroy, @proposal
    @proposal.destroy

    respond_to do |format|
      format.html {
        flash[:notice] = t('info.proposal.proposal_deleted')
        redirect_to(proposals_url)
      }
      format.xml { head :ok }
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
  #se è indicato un group_id cerca anche tra quelle interne a quel gruppo
  def similar
    tags = params[:tags].downcase.gsub('.', '').gsub("'", "").split(",").map { |t| "'#{t.strip}'" }.join(",").html_safe
    if tags.empty?
      tags = "''"
    end
    sql_q ="SELECT p.id, p.proposal_state_id, p.proposal_category_id, p.title, p.content, 
            p.created_at, p.updated_at, p.valutations, p.vote_period_id, p.proposal_comments_count,
            p.rank, p.problem, p.subtitle, p.problems, p.objectives, p.show_comment_authors, COUNT(*) AS closeness
            FROM proposal_tags pt join proposals p on pt.proposal_id = p.id"
    sql_q += " left join group_proposals gp on gp.proposal_id = p.id " if params[:group_id]
    sql_q += " WHERE pt.tag_id IN (SELECT pti.id
               FROM tags pti
               WHERE pti.text in (#{tags}))"
    sql_q += " AND (p.private = false OR p.visible_outside = true "
    sql_q += params[:group_id] ? " OR (p.private = true AND gp.group_id = #{@group.id.to_s}))" : ")"
    sql_q +=" GROUP BY p.id, p.proposal_state_id, p.proposal_category_id, p.title, p.content, 
p.created_at, p.updated_at, p.valutations, p.vote_period_id, p.proposal_comments_count, 
p.rank, p.problem, p.subtitle, p.problems, p.objectives, p.show_comment_authors
                                      ORDER BY closeness DESC"
    @similars = Proposal.find_by_sql(sql_q)

    respond_to do |format|
      format.js
      format.html
    end
  end

  #questo metodo permette all'utente corrente di mettersi a disposizione per redigere la sintesi della proposta
  def available_author
    @proposal.available_user_authors << current_user
    @proposal.save!

    #invia le notifiche
    notify_user_available_authors(@proposal)

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
      users = @proposal.available_user_authors.all(:conditions => ['users.id in (?)', available_ids.map { |id| id.to_i }]) rescue []
      @proposal.available_user_authors -= users
      @proposal.users << users
      @proposal.save!

      #invia le notifiche
      users.each do |u|
        notify_user_choosed_as_author(u, @proposal)
        generate_nickname(u, @proposal)
      end
    end

    flash[:notice] = t('info.proposal.editors_added')
    respond_to do |format|
      format.js { render :update do |page|
        page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
        page.replace_html "authors_list", :partial => 'proposals/authors_list_panel'
        page.replace_html "available_authors_button", :partial => 'proposals/available_authors_button'
        page << "$('#available_authors_list_container').dialog('close');"
      end
      }
    end

  rescue Exception => e
    flash[:error] = t('error.proposals.editors_added')
    respond_to do |format|
      format.js { render :update do |page|
        page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
        page << "$('#available_authors_list_container').dialog('close');"
      end
      }
    end
  end


  def vote_results
    respond_to do |format|
      format.js
    end
  end

  #exlipcitly close the debate of a proposal
  def close_debate
    authorize! :close_debate, @proposal

    Proposal.transaction do
      if @proposal.rank >= @proposal.quorum.good_score
        @proposal.proposal_state_id = ProposalState::WAIT_DATE #metti la proposta in attesa di una data per la votazione
        notify_proposal_ready_for_vote(@proposal, @group)

        #elimina il timer se vi è ancora associato
        if @proposal.quorum.minutes
          Resque.remove_delayed(ProposalsWorker, {:action => ProposalsWorker::ENDTIME, :proposal_id => @proposal.id})
        end

      elsif @proposal.rank < @proposal.quorum.bad_score
        abandon(@proposal)
        notify_proposal_abandoned(@proposal, @group)

        #elimina il timer se vi è ancora associato
        if @proposal.quorum.minutes
          Resque.remove_delayed(ProposalsWorker, {:action => ProposalsWorker::ENDTIME, :proposal_id => @proposal.id})
        end
      end
      @proposal.save!
    end
    redirect_to @proposal

  rescue Exception => e
    puts e
    flash[:error] = t('error.proposals.close_debate')
    respond_to do |format|
      format.js { render :update do |page|
        page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
      end
      }
      format.html {
        flash[:notice] = t('info.proposal.proposal_deleted')
        redirect_to(@proposal)
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
    if params[:view] == ORDER_BY_RANK
      order << " proposals.rank desc, proposals.created_at desc"
    elsif params[:view] == ORDER_BY_VOTES
      order << " proposals.valutations desc, proposals.created_at desc"
    else
      order << "proposals.updated_at desc, proposals.created_at desc"
    end

    conditions = "1 = 1"
    includes = [:proposal_supports, :group_proposals, :area_proposals]
    if params[:state] == VOTATION_STATE
      startlist = Proposal.in_votation
      @replace_id = t("pages.proposals.index.voting").gsub(' ', '_')
    elsif params[:state] == ACCEPTED_STATE
      startlist = Proposal.voted
      @replace_id = t("pages.proposals.index.accepted").gsub(' ', '_')
    elsif params[:state] == REVISION_STATE
      startlist = Proposal.revision
      @replace_id = t("pages.proposals.index.revision").gsub(' ', '_')
    else
      startlist = Proposal.in_valutation
      @replace_id = t("pages.proposals.index.debate").gsub(' ', '_')
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
      conditions += "      or (group_proposals.group_id = " + @group.id.to_s + " and proposals.visible_outside = 't')"
      if can? :view_proposal, @group
        conditions += " or (group_proposals.group_id = " + @group.id.to_s + " and proposals.private = 't')"
      end
      conditions += ")"


      if params[:group_area_id]
        conditions += " and (area_proposals.group_area_id = " + @group_area.id.to_s + "and ((proposals.visible_outside = 't')"
        if current_user
          conditions += " or (proposals.private = 't' and area_proposals.group_area_id in (#{current_user.scoped_areas(@group, GroupAction::PROPOSAL_VIEW).select('group_areas.id').to_sql}))"
        end
        conditions += "))"
      else
        if current_user
          conditions += " and (area_proposals.group_area_id is null or area_proposals.group_area_id in (#{current_user.scoped_areas(@group, GroupAction::PROPOSAL_VIEW).select('group_areas.id').to_sql}) or proposals.visible_outside = 't')"
        end
      end


      #startlist = startlist.private
    else
      startlist = startlist.public
    end

    @proposals = startlist.includes(includes).paginate(:page => params[:page], :per_page => PROPOSALS_PER_PAGE, :conditions => conditions, :order => order)
  end

  def update_borders(borders)
    #confini di interesse, scorrili
    borders.split(',').each do |border| #l'identificativo è nella forma 'X-id'
      ftype = border[0, 1] #tipologia (primo carattere)
      fid = border[2..-1] #chiave primaria (dal terzo all'ultimo carattere)
      found = InterestBorder.table_element(border)

      if found #se ho trovato qualcosa, allora l'identificativo è corretto e posso procedere alla creazione del confine di interesse
        interest_b = InterestBorder.find_or_create_by_territory_type_and_territory_id(InterestBorder::I_TYPE_MAP[ftype], fid)
        i = @proposal.proposal_borders.build({:interest_border_id => interest_b.id})
      end
    end if borders
  end


  #valuta una proposta
  def rank(rank_type)
    if @my_ranking #se essite già una mia valutazione, aggiornala
      @ranking = @my_ranking
    else #altrimenti creane una nuova
      @ranking = ProposalRanking.new
      @ranking.user_id = current_user.id
      @ranking.proposal_id = params[:id]
      notify_user_valutate_proposal(@ranking,@group) #invia notifica per indicare la nuova valutazione
    end
    @ranking.ranking_type_id = rank_type #setta il tipo di valutazione

    ProposalRanking.transaction do
      saved = @ranking.save
      @proposal.reload
      check_phase(@proposal)

      respond_to do |format|
        if saved
          load_my_vote
          flash[:notice] = t('info.proposal.rank_recorderd')
          format.js { render 'rank'
          }
          format.html
        else
          flash[:notice] = t('error.proposals.proposal_rank')
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
    flash[:notice] = t('error.proposals.proposal_rank')
    respond_to do |format|
      format.js { render :update do |page|
        page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
        page.replace_html "rankleftpanel", :partial => 'proposals/rank_left_panel'

      end
      }
      format.html
    end
  end

  #carica l'area di lavoro
  def load_group_area
    @group_area = GroupArea.find(params[:group_area_id]) if params[:group_area_id]
  end


  def load_proposal_and_group
    @proposal = Proposal.find(params[:id])
    @pgroup = params[:group_id] ? Group.find(params[:group_id]) : request.subdomain ? Group.find_by_subdomain(request.subdomain) : nil

    if @pgroup && !(@proposal.presentation_groups.include? @pgroup) && !(@proposal.groups.include? @pgroup)
      raise ActiveRecord::RecordNotFound
    elsif @proposal.presentation_groups.count > 0 && !params[:group_id] && request.subdomain.empty?
      redirect_to group_proposal_url(@proposal.presentation_groups.first, @proposal, :format => params[:format])
    end
    load_my_vote
  end

  def load_proposal
    @proposal = @group ? @group.internal_proposals.find(params[:id]) : Proposal.find(params[:id])
  end

  def load_my_vote
    if @proposal.proposal_state_id != PROP_VALUT
      @can_vote_again = 0
    else
      ranking = ProposalRanking.find_by_user_id_and_proposal_id(current_user.id, @proposal.id) if current_user
      @my_vote = ranking.ranking_type_id if ranking
      if @my_vote
        if ranking.updated_at < @proposal.updated_at
          flash.now[:info] = t('info.proposal.can_change_valutation') if ['show', 'update'].include? params[:action]
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
      flash[:error] = t('error.proposals.proposal_not_your')
      redirect_to proposals_path
    end
  end

  def can_view
    unless can? :read, @proposal
      flash[:error] = t('error.permissions_required')
      respond_to do |format|
        format.js { render :update do |page|
          page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
        end
        }
        format.html {
          redirect_to :back
        }
      end
    end
  end


  def voted_state_required
    unless @proposal.voted?
      flash[:error] = t('error.proposals.proposal_not_voted')
      respond_to do |format|
        format.js { render :update do |page|
          page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
        end
        }
        format.html {
          redirect_to :back
        }
      end
    end
  end

  def valutation_state_required
    if @proposal.proposal_state_id != PROP_VALUT
      flash[:error] = t('error.proposals.proposal_not_valuating')
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
    @my_ranking = ProposalRanking.find_by_user_id_and_proposal_id(current_user.id, params[:id])
    @my_vote = @my_ranking.ranking_type_id if @my_ranking
    if ((@my_vote && @my_ranking.updated_at > @proposal.updated_at) ||
        (@proposal.private && @group && !(can? :partecipate, @proposal)))
      flash[:error] = t('error.proposals.proposal_already_ranked')
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


  private

  def render_404(exception=nil)
    log_error(exception) if exception
    respond_to do |format|
      @title = t('error.404.proposals.title')
      @message = t('error.404.proposals.description')
      format.html { render "errors/404", :status => 404, :layout => true }
    end
    true
  end
end
