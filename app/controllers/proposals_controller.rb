class ProposalsController < ApplicationController
  include ProposalsHelper

  before_filter :load_group
  before_filter :load_group_area

  before_filter :authorize_parent

  def authorize_parent
    authorize! :read, @group if @group
    authorize! :read, @group_area if @group_area
  end

  load_and_authorize_resource through: [:group, :group_area], shallow: true, except: [:tab_list, :similar, :endless_index]
  skip_authorize_resource only: :vote_results

  layout :choose_layout

  #la proposta deve essere in stato 'IN VALUTAZIONE'
  before_filter :valutation_state_required, only: [:rankup, :rankdown, :available_author, :add_authors, :geocode]

  before_filter :check_page_alerts, only: :show

  def index
    populate_search

    if @group
      authorize! :view_data, @group

      unless can? :view_proposal, @group
        flash.now[:warn] = 'Non hai i permessi per visualizzare le proposte private. Contatta gli amministratori del gruppo.' #TODO:I18n
      end

      if params[:group_area_id]
        unless can? :view_proposal, @group_area
          flash.now[:warn] = 'Non hai i permessi per visualizzare le proposte private. Contatta gli amministratori del gruppo.' #TODO:I18n
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

      format.html {
        render 'tab_list', layout: false
      }
      format.js
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
      format.html { render 'banner', layout: false }
      format.js
    end
  end

  def test_banner
    @proposal = Proposal.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def show
    return redirect_to redirect_url(@proposal) if wrong_url?

    @proposal.check_phase #todo checks only the state during the debate. this is a security check, so if the background job didn't run we can always fix it/ we should check also for waiting and vote inconsistent phase.
    @proposal.reload
    if @proposal.private #la proposta è interna ad un gruppo
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
    end

    @my_nickname = current_user.proposal_nicknames.find_by_proposal_id(@proposal.id) if current_user

    load_my_vote
    respond_to do |format|
      format.html {
        flash.now[:info] = I18n.t('info.proposal.public_visible') if @proposal.visible_outside
        register_view(@proposal, current_user)
        @blocked_alerts = BlockedProposalAlert.find_by_user_id_and_proposal_id(current_user.id, @proposal.id) if current_user
        if @proposal.voting?
          flash.now[:info] = I18n.t('info.proposal.voting')
        end
      }
      format.js {
        render nothing: true
      }
      format.json
      format.pdf {
        render pdf: 'show.pdf.erb',
               show_as_html: params[:debug].present?
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
    max = current_user.proposals.maximum(:created_at) || Time.now - (PROPOSALS_TIME_LIMIT + 1.seconds)
    raise Exception if LIMIT_PROPOSALS && ((Time.now - max) < PROPOSALS_TIME_LIMIT)

    @proposal.current_user_id = current_user.id
    if @proposal.save
      respond_to do |format|
        flash[:notice] = I18n.t('info.proposal.proposal_created')
        format.js
        format.html {
          if request.env['HTTP_REFERER']['back=home']
            redirect_to home_url
          else
            redirect_to @group ? edit_group_proposal_url(@group, @proposal) : edit_proposal_path(@proposal)
          end
        }
      end
    else
      if @proposal.errors[:title].present?
        @other = Proposal.find_by(title: @proposal.title)
        @err_msg = t('error.proposals.same_title')
      elsif !@proposal.errors.empty?
        @err_msg = @proposal.errors.full_messages.join(',')
      else
        @err_msg = I18n.t('error.proposals.creation')
      end
      respond_to do |format|
        format.html { render action: :new }
        format.js { render 'error_create' }
      end
    end
  end

  #put back in debate a proposal
  def regenerate
    authorize! :regenerate, @proposal
    @proposal.current_user_id = current_user.id
    @proposal.regenerate(regenerate_proposal_params)
    flash[:notice] = t('info.proposal.back_in_debate')
    respond_to do |format|
      format.html {
        redirect_to redirect_url(@proposal)
      }
      format.js
    end
  end

  def update
    @proposal.current_user_id = current_user.id
    if @proposal.update(update_proposal_params)
      PrivatePub.publish_to(proposal_path(@proposal), reload_message) rescue nil
      respond_to do |format|
        flash.now[:notice] = I18n.t('info.proposal.proposal_updated')
        format.html {
          if params[:subaction] == 'save'
            redirect_to @group ? group_proposal_url(@group, @proposal) : @proposal
          else
            @proposal.reload
            render action: 'edit'
          end
        }
      end
    else
      flash[:error] = @proposal.errors.map { |e, msg| msg }[0].to_s
      respond_to do |format|
        format.html { render action: 'edit' }
      end
    end
  end

  def set_votation_date
    if @proposal.waiting_date?
      @proposal.set_votation_date(params[:proposal][:vote_period_id])
      flash[:notice] = I18n.t('info.proposal.date_selected')
    else
      flash[:error] = I18n.t('error.proposals.proposal_not_waiting_date')
    end
    redirect_to @group ? group_proposal_url(@group, @proposal) : proposal_url(@proposal)
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
          page.replace_html 'statistics_panel', partial: 'statistics', locals: {proposal: @proposal}
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
      format.html
      format.js
    end
  end

  #questo metodo permette all'utente corrente di mettersi a disposizione per redigere la sintesi della proposta
  def available_author
    @proposal.available_user_authors << current_user
    @proposal.save!
    flash[:notice] = I18n.t('info.proposal.offered_editor')
  end

  #restituisce la lista degli utenti disponibili a redigere la sintesi della proposta
  def available_authors_list
    @available_authors = @proposal.available_user_authors
    respond_to do |format|
      format.js
    end
  end

  #add available authors as authors to the proposal
  def add_authors
    available_ids = params['user_ids']
    Proposal.transaction do
      users = @proposal.available_user_authors.where(users: {id: available_ids.map(&:to_i)})
      @proposal.available_user_authors -= users
      users.each do |user|
        @proposal.proposal_presentations.build(user: user, acceptor: current_user)
      end
      @proposal.save!
      @proposal.reload
    end
    flash[:notice] = t('info.proposal.authors_added')
  rescue Exception => e
    flash[:error] = t('errors.proposal.authors_added')
    render 'layouts/error'
  end


  def vote_results
    return redirect_to vote_results_group_proposal_path(@proposal.group, @proposal) if wrong_url?
    authorize! :show, @proposal
  end

  # exlipcitly close the debate of a proposal
  def close_debate
    authorize! :close_debate, @proposal
    @proposal.check_phase(true)
    redirect_to @proposal
  end

  # explicitly start the votation of a proposal
  def start_votation
    @proposal.start_votation
    redirect_to @proposal
  end

  protected


  #the url is wrong if you try to access a private proposal without indicating the group
  #we redirect you to the corret url
  #todo when there will be more groups we cannot do that anymore
  def wrong_url?
    @proposal.private? && !@group
  end

  def choose_layout
    @group ? 'groups' : 'open_space'
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
    ProposalRanking.transaction do
      ranking = @proposal.rankings.find_or_create_by(user_id: current_user.id)
      ranking.ranking_type_id = rank_type
      ranking.save!
      @proposal.reload
      load_my_vote
    end

    flash[:notice] = I18n.t('info.proposal.rank_recorderd')
    respond_to do |format|
      format.js { render 'rank' }
      format.html { redirect_to :back }
    end
  rescue Exception => e
    log_error(e)
    flash[:error] = I18n.t('error.proposals.proposal_rank')
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { render 'proposals/errors/rank' }
    end
  end

  #carica l'area di lavoro
  def load_group_area
    @group_area = @group.group_areas.find(params[:group_area_id]) if @group && params[:group_area_id]
  end

  #fill @my_vote and @can_vote_again variables
  def load_my_vote
    return unless @proposal.in_valutation?
    ranking = ProposalRanking.find_by(user_id: current_user.id, proposal_id: @proposal.id) if current_user
    @my_vote = ranking.ranking_type_id if ranking

    if @my_vote
      if ranking.updated_at < @proposal.updated_at
        flash.now[:info] = I18n.t('info.proposal.can_change_valutation') if ['show', 'update'].include? params[:action]
        @can_vote_again = true
      end
    else
      @can_vote_again = true
    end
  end

  def valutation_state_required
    return if @proposal.in_valutation?
    flash[:error] = I18n.t('error.proposals.proposal_not_valuating')
    respond_to do |format|
      format.html { redirect_to :back }
      format.js { render 'proposals/errors/rank', layout: false }
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

    @search.interest_border = if params[:interest_border].nil?
                                InterestBorder.find_or_create_by(territory: current_domain.territory)
                              else
                                InterestBorder.find_or_create_by_key(params[:interest_border])
                              end

    # apply filter for the group
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
                                     :integrated_contributes_ids_list, :signatures, :petition_phase,
                                     votation: [:later, :start, :start_edited, :end],
                                     sections_attributes:
                                       [:id, :seq, :_destroy, :title, paragraphs_attributes:
                                             [:id, :seq, :content, :content_dirty]],
                                     solutions_attributes:
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
    log_error(exception) if exception
    respond_to do |format|
      @title = I18n.t('error.error_404.proposals.title')
      @message = I18n.t('error.error_404.proposals.description')
      format.html { render 'errors/404', status: 404, layout: true }
    end
    true
  end

  def register_view(proposal, user)
    proposal.register_view_by(user)
  end
end
