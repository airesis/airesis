#encoding: utf-8
class ProposalsController < ApplicationController
  include NotificationHelper, ProposalsModule, GroupsHelper

  before_filter :load_group
  before_filter :load_group_area

  before_filter :authorize_parent

  def authorize_parent
    authorize! :read, @group if @group
    authorize! :read, @group_area if @group_area
  end

  load_and_authorize_resource through: [:group, :group_area], shallow: true, except: [:tab_list, :similar, :endless_index]

  layout :choose_layout

  #la proposta deve essere in stato 'IN VALUTAZIONE'
  before_filter :valutation_state_required, only: [:rankup, :rankdown, :available_author, :add_authors, :geocode]

  #l'utente deve poter valutare la proposta
  before_filter :can_valutate, only: [:rankup, :rankdown]

  before_filter :check_page_alerts, only: :show

  def index
    populate_search

    if @group
      authorize! :view_data, @group

      unless can? :view_proposal, @group
        flash.now[:warn] = "Non hai i permessi per visualizzare le proposte private. Contatta gli amministratori del gruppo." #TODO:I18n
      end

      if params[:group_area_id]
        unless can? :view_proposal, @group_area
          flash.now[:warn] = "Non hai i permessi per visualizzare le proposte private. Contatta gli amministratori del gruppo." #TODO:I18n
        end
      end
    end

    @search.proposal_state_id = ProposalState::TAB_DEBATE
    @in_valutation_count = @search.results.total_entries
    @search.proposal_state_id = ProposalState::TAB_VOTATION
    @in_votation_count = @search.results.total_entries
    @search.proposal_state_id = ProposalState::TAB_VOTED
    @accepted_count = @search.results.total_entries
    @search.proposal_state_id = ProposalState::TAB_REVISION
    @revision_count = @search.results.total_entries

    respond_to do |format|
      format.html {
        @page_head = ''

        if params[:category]
          @page_head += t('pages.proposals.index.title_with_category', category: ProposalCategory.find(params[:category]).description)
        else
          @page_head += t('pages.proposals.index.title')
        end

        if params[:type]
          @page_head += " #{t('pages.propsoals.index.type', type: ProposalType.find(params[:type]).description)}"
        end

        if params[:time]
          if params[:time][:type] == 'f'
            @page_head += " #{t('pages.proposals.index.date_range', start: params[:time][:start_w], end: params[:time][:end_w])}"
          elsif params[:time][:type] == '1h'
            @page_head += " #{t('pages.proposals.index.last_1h')}"
          elsif params[:time][:type] == '24h'
            @page_head += " #{t('pages.proposals.index.last_24h')}"
          elsif params[:time][:type] == '7d'
            @page_head += " #{t('pages.proposals.index.last_7d')}"
          elsif params[:time][:type] == '1m'
            @page_head += " #{t('pages.proposals.index.last_1m')}"
          elsif params[:time][:type] == '1y'
            @page_head += " #{t('pages.proposals.index.last_1y')}"
          end
        end
        if params[:search]
          @page_head += " #{t('pages.proposals.index.with_text', text: params[:search])}"
        end
        @page_head += " #{t('pages.proposals.index.in_group_area_title')} '#{@group_area.name}'" if @group_area

        @page_title = @page_head
      }
      format.json
    end

  end

  #list all proposals in a state
  def tab_list
    authorize! :index, Proposal
    query_index
    respond_to do |format|
      if params[:replace]
        format.js
      else
        format.html { render "tab_list", layout: false }
      end
      format.json
    end
  end

  def endless_index
    authorize! :index, Proposal
    query_index
    respond_to do |format|
      format.js
    end
  end

  def banner
    @proposal = Proposal.find(params[:id])
    respond_to do |format|
      format.js
      format.html { render 'banner', layout: false }
    end
  end

  def test_banner
    @proposal = Proposal.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def show
    if @proposal.private
      if @group #la proposta è interna ad un gruppo
        if @proposal.visible_outside #se è visibile dall'esterno mostra solo un messaggio
          if !current_user
            flash[:info] = I18n.t('info.proposal.ask_participation')
          elsif !(can? :participate, @proposal) && @proposal.in_valutation?
            flash[:info] = I18n.t('error.proposals.participate')
          end
        else #se è bloccata alla visione di utenti esterni
          if !current_user #se l'utente non è loggato richiedi l'autenticazione
            authenticate_user!
          elsif !(can? :show, @proposal) #se è loggato ma non ha i permessi caccialo fuori
            respond_to do |format|
              flash[:error] = I18n.t('error.proposals.view_proposal')
              format.html {
                redirect_to group_proposals_path(@group)
              }
              format.json {
                render json: {error: flash[:error]}, status: 401
                return
              }
            end
          end
          if !(can? :participate, @proposal) && @proposal.in_valutation?
            flash[:info] = I18n.t('error.proposals.participate')
          end
        end
      else
        redirect_to redirect_url(@proposal) and return
      end

    end

    flash.now[:info] = I18n.t('info.proposal.public_visible') if @proposal.visible_outside

    @my_nickname = current_user.proposal_nicknames.find_by_proposal_id(@proposal.id) if current_user
    @blocked_alerts = BlockedProposalAlert.find_by_user_id_and_proposal_id(current_user.id, @proposal.id) if current_user
    register_view(@proposal, current_user)

    respond_to do |format|
      format.js {
        render nothing: true
      }
      format.html {
        if @proposal.proposal_state_id == ProposalState::WAIT_DATE.to_s
          flash.now[:info] = I18n.t('info.proposal.waiting_date')
        elsif @proposal.proposal_state_id == ProposalState::VOTING.to_s
          flash.now[:info] = I18n.t('info.proposal.voting')
        end
      }
      format.json
      format.pdf {
        if @proposal.voted?
          render pdf: 'show.pdf.erb',
                 show_as_html: params[:debug].present?
        else
          flash[:error] = "E' possibile esportare in pdf solo le proposte terminate"
          redirect_to @proposal, format: 'html'
        end
      }
    end
  end

  def new
    if LIMIT_PROPOSALS
      max = current_user.proposals.maximum(:created_at) || Time.now - (PROPOSALS_TIME_LIMIT + 1.seconds)
      @elapsed = Time.now - max
      if @elapsed < PROPOSALS_TIME_LIMIT
        respond_to do |format|
          format.js { render 'error_new' }
        end
        return
      end
    end

    if @group
      @proposal.interest_borders << @group.interest_border
      @proposal.private = true
      @proposal.anonima = @group.default_anonima
      @proposal.visible_outside = @group.default_visible_outside
      @proposal.change_advanced_options = @group.change_advanced_options

      if params[:group_area_id]
        @proposal.group_area_id = params[:group_area_id]
      end

      if params[:topic_id]
        @topic = @group.topics.find(params[:topic_id])
        (@proposal.topic_id = params[:topic_id]) if can? :read, @topic
      end
    end

    @proposal.proposal_category_id = params[:category] || ProposalCategory::NO_CATEGORY

    @proposal.proposal_type = ProposalType.find_by(name: (params[:proposal_type_id] || ProposalType::SIMPLE))

    @proposal.build_sections

    @title = ''
    @title += I18n.t('pages.proposals.new.title_group', name: @group.name)+ ' ' if @group
    @title += @proposal.proposal_type.description
  end

  def edit
    @proposal.change_advanced_options = @group ?
        @group.change_advanced_options :
        DEFAULT_CHANGE_ADVANCED_OPTIONS
  end


  def geocode

  end

  def create
    begin
      max = current_user.proposals.maximum(:created_at) || Time.now - (PROPOSALS_TIME_LIMIT + 1.seconds)
      raise Exception if LIMIT_PROPOSALS && ((Time.now - max) < PROPOSALS_TIME_LIMIT)

      #send(@proposal.proposal_type.name.downcase + '_create', @proposal) #execute specific method to build sections
      @proposal.current_user_id = current_user.id
      if @proposal.save
        generate_nickname(current_user, @proposal)
        respond_to do |format|
          flash[:notice] = I18n.t('info.proposal.proposal_created')
          format.js
          format.html {
            if request.env['HTTP_REFERER']["back=home"]
              redirect_to home_url
            else
              redirect_to @group ? edit_group_proposal_url(@group, @proposal) : edit_proposal_path(@proposal)
            end
          }
        end
      else
        if !@proposal.errors[:title].empty?
          @other = Proposal.find_by_title(params[:proposal][:title])
          @err_msg = "Esiste già un altra proposta con lo stesso titolo"
        elsif !@proposal.errors.empty?
          @err_msg = @proposal.errors.full_messages.join(",")
        else
          @err_msg = I18n.t('error.proposals.creation')
        end
        respond_to do |format|
          format.js { render 'error_create' }
          format.html { render action: :new }
        end
      end
    end
  end

  #put back in debate a proposal
  def regenerate
    authorize! :regenerate, @proposal
    Proposal.transaction do
      @proposal.proposal_state_id = ProposalState::VALUTATION
      @proposal.users << current_user

      if @proposal.update(regenerate_proposal_params)
        quorum = assign_quorum(params[:proposal])
        #fai partire il timer per far scadere la proposta
        if quorum.minutes # && params[:proposal][:proposal_type_id] == ProposalType::STANDARD.to_s
          ProposalsWorker.perform_at(@copy.ends_at, {action: ProposalsWorker::ENDTIME, proposal_id: @proposal.id})
        end

        generate_nickname(current_user, @proposal)


        #if the time is fixed we schedule notifications 24h and 1h before the end of debate
        if @copy.time_fixed?
          ProposalsWorker.perform_at(@copy.ends_at - 24.hours, {action: ProposalsWorker::LEFT24, proposal_id: @proposal.id}) if @copy.minutes > 1440
          ProposalsWorker.perform_at(@copy.ends_at - 1.hour, {action: ProposalsWorker::LEFT1, proposal_id: @proposal.id}) if @copy.minutes > 60
        end


        flash[:notice] = I18n.t('info.proposal.back_in_debate')
        respond_to do |format|
          format.js
          format.html {
            redirect_to redirect_url(@proposal)
          }
        end
      end
    end
  rescue Exception => e
    puts e
    if !@proposal.errors[:title].empty?
      @other = Proposal.find_by_title(params[:proposal][:title])
      @err_msg = "Esiste già un altra proposta con lo stesso titolo"
    elsif !@proposal.errors.empty?
      @err_msg = @proposal.errors.full_messages.join(",")
    else
      @err_msg = 'Error during the update of the proposal'
    end
    respond_to do |format|
      format.js { render 'error_regenerate' }
      format.html { render action: "show" }
    end
  end

  def update
    @proposal.current_user_id = current_user.id
    if @proposal.update(update_proposal_params)
      PrivatePub.publish_to(proposal_path(@proposal), reload_message) rescue nil

      respond_to do |format|
        flash.now[:notice] = I18n.t('info.proposal.proposal_updated')
        format.html {
          if params[:commit] == t('buttons.update')
            redirect_to @group ? group_proposal_url(@group, @proposal) : @proposal
          else
            @proposal.reload
            render action: "edit"
          end
        }
      end
    else
      flash[:error] = e.record.errors.map { |e, msg| msg }[0].to_s
      respond_to do |format|
        format.html { render action: "edit" }
      end
    end
  end

  def set_votation_date
    if @proposal.proposal_state_id != PROP_WAIT_DATE
      flash[:error] = I18n.t('error.proposals.proposal_not_waiting_date')
      respond_to do |format|
        format.js { render :update do |page|
          page.replace_html "flash_messages", partial: 'layouts/flash', locals: {flash: flash}
        end
        }
        format.html { redirect_to @group ? group_proposal_url(@group, @proposal) : proposal_url(@proposal) }
      end
    else
      vote_period = Event.find(params[:proposal][:vote_period_id])
      raise Exception unless vote_period.starttime > (Time.now + 5.seconds) #security check
      @proposal.vote_period_id = params[:proposal][:vote_period_id]
      @proposal.proposal_state_id = PROP_WAIT
      @proposal.save!
      notify_proposal_waiting_for_date(@proposal, @group)
      flash[:notice] = I18n.t('info.proposal.date_selected')
      respond_to do |format|
        format.js do
          render :update do |page|
            page.replace_html "flash_messages", partial: 'layouts/flash', locals: {flash: flash}
          end
        end
        format.html { redirect_to @group ? group_proposal_url(@group, @proposal) : proposal_url(@proposal) }
      end
    end

  rescue Exception => boom
    flash[:error] = I18n.t('error.proposals.updating')
    redirect_to :back
  end


  def destroy
    authorize! :destroy, @proposal
    @proposal.destroy
    flash[:notice] = I18n.t('info.proposal.proposal_deleted')
    redirect_to @group ? group_proposals_url(@group) : proposals_url
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
          page.replace_html "statistics_panel", partial: 'statistics', locals: {proposal: @proposal}
        end
      end
    end
  end

  #restituisce una lista di tutte le proposte simili a quella
  #passata come parametro
  #se è indicato un group_id cerca anche tra quelle interne a quel gruppo
  def similar
    authorize! :index, Proposal
    tags = params[:tags].downcase.gsub('.', '').gsub("'", '').split(',').map { |t| t.strip }.join(' ').html_safe if params[:tags]
    search_q = "#{params[:title]} #{tags}"

    search = SearchProposal.new(text: search_q)

    search.user_id = current_user.id if current_user
    search.group_id = @group.id if @group
    @proposals = search.similar

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

    flash[:notice] = I18n.t('info.proposal.offered_editor')

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
      users = @proposal.available_user_authors.where(['users.id in (?)', available_ids.map { |id| id.to_i }]).all rescue []
      @proposal.available_user_authors -= users
      @proposal.users << users
      @proposal.save!

      #invia le notifiche
      users.each do |u|
        notify_user_choosed_as_author(u, @proposal)
        generate_nickname(u, @proposal)
      end
    end
    flash[:notice] = "Nuovi redattori aggiunti correttamente!"
  rescue Exception => e
    flash[:error] = "Errore durante l'aggiunta dei nuovi autori"
    render 'proposals/errors/add_authors'
  end


  def vote_results
  end

  #exlipcitly close the debate of a proposal
  def close_debate
    authorize! :close_debate, @proposal

    Proposal.transaction do
      check_phase(@proposal, true)
    end
    redirect_to @proposal

  rescue Exception => e
    puts e
    flash[:error] = "Errore durante la chiusura del dibattito"
    respond_to do |format|
      format.js { render :update do |page|
        page.replace_html "flash_messages", partial: 'layouts/flash', locals: {flash: flash}
      end
      }
      format.html {
        flash[:notice] = I18n.t('info.proposal.proposal_deleted')
        redirect_to(@proposal)
      }
    end
  end

  def facebook_share
    @page_title = "Invite friends to join this proposal"
    respond_to do |format|
      format.html {

      }
      format.js {
        #session[:add_authorizations] = true
        #redirect_to '/auth/facebook?scope=xmpp_login'
      }
    end

  end

  def facebook_send_message
    @friend_id = params[:message][:friend_id]

    unless Rails.env == 'development'
      body = params[:message][:body] + "\n" + params[:message][:url]
      id = "-#{current_user.authentications.find_by_provider(Authentication::FACEBOOK).uid}@chat.facebook.com"
      to = "-#{@friend_id}@chat.facebook.com"
      subject = 'Message from Airesis'
      message = Jabber::Message.new to, body
      message.subject = subject
      client = Jabber::Client.new Jabber::JID.new(id)
      client.connect
      client.auth_sasl(Jabber::SASL::XFacebookPlatform.new(client, ENV['FACEBOOK_APP_ID'], current_user.authentications.find_by_provider(Authentication::FACEBOOK).token, ENV['FACEBOOK_APP_SECRET']), nil)
      client.send message
      client.close
    end
    respond_to do |format|
      format.js
    end
  end

  protected

  def choose_layout
    @group ? "groups" : "open_space"
  end


  #query per la ricerca delle proposte
  def query_index
    populate_search

    if params[:state] == ProposalState::TAB_VOTATION.to_s
      @replace_id = 'votation'
    elsif params[:state] == ProposalState::TAB_VOTED.to_s
      @replace_id = 'accepted'
    elsif params[:state] == ProposalState::TAB_REVISION.to_s
      @replace_id = 'revision'
    else
      @replace_id = 'debate'
    end


    @proposals = @search.results
  end


  #valuta una proposta
  def rank(rank_type)
    if @my_ranking #se essite già una mia valutazione, aggiornala
      @ranking = @my_ranking
    else #altrimenti creane una nuova
      @ranking = ProposalRanking.new
      @ranking.user_id = current_user.id
      @ranking.proposal_id = params[:id]
      notify_user_valutate_proposal(@ranking, @group) #invia notifica per indicare la nuova valutazione
    end
    @ranking.ranking_type_id = rank_type #setta il tipo di valutazione

    ProposalRanking.transaction do
      saved = @ranking.save!
      @proposal.reload
      check_phase(@proposal)

      load_my_vote

    end #transaction
    flash[:notice] = I18n.t('info.proposal.rank_recorderd')
    respond_to do |format|
      format.js { render 'rank'
      }
      format.html
    end
  rescue Exception => e
#    log_error(e)
    flash[:error] = I18n.t('error.proposals.proposal_rank')
    respond_to do |format|
      format.js { render :update do |page|
        page.replace_html "flash_messages", partial: 'layouts/flash', locals: {flash: flash}
        page.replace_html "rankleftpanel", partial: 'proposals/rank_left_panel'
        page.replace_html "dates", partial: 'proposals/dates'

      end
      }
      format.html
    end
  end

  #carica l'area di lavoro
  def load_group_area
    @group_area = @group.group_areas.find(params[:group_area_id]) if @group && params[:group_area_id]
  end

  def load_my_vote
    if @proposal.proposal_state_id != PROP_VALUT
      @can_vote_again = 0
    else
      ranking = ProposalRanking.find_by_user_id_and_proposal_id(current_user.id, @proposal.id) if current_user
      @my_vote = ranking.ranking_type_id if ranking
      if @my_vote
        if ranking.updated_at < @proposal.updated_at
          flash.now[:info] = I18n.t('info.proposal.can_change_valutation') if ['show', 'update'].include? params[:action]
          @can_vote_again = 1
        else
          @can_vote_again = 0
        end
      else
        @can_vote_again = 1
      end
    end
  end

  def valutation_state_required
    if @proposal.proposal_state_id != PROP_VALUT
      flash[:error] = I18n.t('error.proposals.proposal_not_valuating')
      respond_to do |format|
        format.js { render :update do |page|
          page.replace_html "flash_messages", partial: 'layouts/flash', locals: {flash: flash}
          page.replace_html "rankingpanelcontainer", partial: 'proposals/ranking_panel', locals: {flash: flash}
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
        (@proposal.private && @group && !(can? :participate, @proposal)))
      flash[:error] = I18n.t('error.proposals.proposal_already_ranked')
      respond_to do |format|
        format.js { render :update do |page|
          page.replace_html "flash_messages", partial: 'layouts/flash', locals: {flash: flash}
          page.replace_html "rankingpanelcontainer", partial: 'proposals/ranking_panel', locals: {flash: flash}
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


  def populate_search
    @search = SearchProposal.new
    @search.order_id = params[:view]
    @search.order_dir = params[:order]

    if current_user
      @search.user_id = current_user.id
    end

    @search.proposal_type_id = params[:type]

    @search.proposal_state_id = params[:state]

    @search.proposal_category_id = params[:category]

    #applica il filtro per il gruppo
    if @group
      @search.group_id = @group.id
      if params[:group_area_id]
        @group_area = GroupArea.find(params[:group_area_id])
        @search.group_area_id = params[:group_area_id]
      end
    end

    if params[:time]
      @search.created_at_from = Time.at(params[:time][:start].to_i/1000) if params[:time][:start]
      @search.created_at_to = Time.at(params[:time][:end].to_i/1000) if params[:time][:end]
      @search.time_type = params[:time][:type]
    end
    @search.text = params[:search]
    @search.or = params[:or]

    @search.page = params[:page] || 1
    @search.per_page = PROPOSALS_PER_PAGE
  end


  private

  def proposal_params
    params.require(:proposal).permit(:proposal_category_id, :content, :title, :interest_borders_tkn, :tags_list,
                                     :private, :anonima, :quorum_id, :visible_outside, :secret_vote, :vote_period_id, :group_area_id, :topic_id,
                                     :proposal_type_id, :proposal_votation_type_id,
                                     :integrated_contributes_ids_list, :votation, :signatures, :petition_phase,
                                     sections_attributes:
                                         [:id, :seq, :_destroy, :title, paragraphs_attributes:
                                             [:id, :seq, :content, :content_dirty]],
                                     :solutions_attributes =>
                                         [:id, :seq, :_destroy, :title, sections_attributes:
                                             [:id, :seq, :_destroy, :title, paragraphs_attributes:
                                                 [:id, :seq, :content, :content_dirty]]])
  end

  def update_proposal_params
    (can? :destroy, @proposal) ?
        proposal_params :
        proposal_params.except(:title, :interest_borders_tkn, :tags_list, :quorum_id, :anonima, :visible_outside, :secret_vote)
  end

  def regenerate_proposal_params
    params.require(:proposal).permit(:quorum_id)
  end

  def render_404(exception=nil)
    #log_error(exception) if exception
    respond_to do |format|
      @title = I18n.t('error.error_404.proposals.title')
      @message = I18n.t('error.error_404.proposals.description')
      format.html { render "errors/404", status: 404, layout: true }
    end
    true
  end

  def register_view(proposal, user)
    proposal.register_view_by(user)
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

    if @group #calcolo il numero in base ai partecipanti
      if @group_area #se la proposta è in un'area di lavoro farà riferimento solo agli utenti di quell'area
        @copy.valutations = ((quorum.percentage.to_f * @group_area.count_proposals_participants.to_f) / 100).floor
        @copy.vote_valutations = ((quorum.vote_percentage.to_f * @group_area.count_voter_participants.to_f) / 100).floor #todo we must calculate it before votation
      else #se la proposta è di gruppo sarà basato sul numero di utenti con diritto di partecipare
        @copy.valutations = ((quorum.percentage.to_f * @group.count_proposals_participants.to_f) / 100).floor
        @copy.vote_valutations = ((quorum.vote_percentage.to_f * @group.count_voter_participants.to_f) / 100).floor #todo we must calculate it before votation
      end
    else #calcolo il numero in base agli utenti del portale (il 10%)
      @copy.valutations = ((quorum.percentage.to_f * User.count.to_f) / 1000).floor
      @copy.vote_valutations = ((quorum.vote_percentage.to_f * User.count.to_f) / 1000).floor
    end
    #deve essere almeno 1!
    @copy.valutations = [@copy.valutations + 1, 1].max #we always add 1 for new quora
    @copy.vote_valutations = [@copy.vote_valutations + 1, 1].max #we always add 1 for new quora

    @copy.public = false
    @copy.assigned = true
    @copy.save!
    @proposal.quorum_id = @copy.id


    #if is time fixed you can choose immediatly vote period
    if @copy.time_fixed?
      #if the user choosed it
      if prparams[:votation] && (prparams[:votation][:later] != 'true')
        #if he took a vote period already existing
        if (prparams[:votation][:choise] && (prparams[:votation][:choise] == 'preset')) || (!prparams[:votation][:choise] && (prparams[:votation][:vote_period_id].to_s != ''))
          @proposal.vote_event_id = prparams[:votation][:vote_period_id]
          @vote_event = Event.find(@proposal.vote_event_id)
          if @vote_event.starttime < Time.now + @copy.minutes.minutes + DEBATE_VOTE_DIFFERENCE #if the vote period start before the end of debate there is an error
            @proposal.errors.add(:vote_event_id, t('error.proposals.vote_period_incorrect'))
            raise Exception
          end
        else #if he created a new period
          start = ((prparams[:votation][:start_edited].to_s != '') && prparams[:votation][:start]) || (@copy.ends_at + DEBATE_VOTE_DIFFERENCE) #look if he edited the starttime or not
          raise Exception 'error' unless prparams[:votation][:end].to_s != ''
          @proposal.vote_starts_at = start
          @proposal.vote_ends_at = prparams[:votation][:end]
          if (@proposal.vote_starts_at - @copy.ends_at) < DEBATE_VOTE_DIFFERENCE
            @proposal.errors.add(:vote_starts_at, t('error.proposals.vote_period_soon', time: DEBATE_VOTE_DIFFERENCE.to_i / 60))
            raise Exception
          end
          if @proposal.vote_ends_at < (@proposal.vote_starts_at + 10.minutes)
            @proposal.errors.add(:vote_ends_at, t('error.proposals.vote_period_short'))
            raise Exception
          end
        end

        @proposal.vote_defined = true
      end
    end
    quorum

  end


end
