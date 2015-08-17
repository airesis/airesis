class GroupsController < ApplicationController

  layout :choose_layout

  before_filter :authenticate_user!, except: [:index, :show, :by_year_and_month]

  before_filter :load_group, except: [:index, :new, :create, :ask_for_multiple_follow]

  load_resource

  authorize_resource except: [:participation_request_confirm, :participation_request_decline]

  before_filter :admin_required, only: [:autocomplete]

  def autocomplete
    groups = Group.autocomplete(params[:term])
    groups = groups.map do |u|
      {id: u.id, identifier: "#{u.name}", image_path: "#{u.group_image_tag 20}"}
    end
    render json: groups
  end

  def index
    unless request.xhr?
      @tags = Tag.most_groups(current_domain.territory, 10).shuffle
    end

    params[:interest_border_obj] = @interest_border = if params[:interest_border].nil?
                                                        InterestBorder.find_or_create_by(territory: current_domain.territory)
                                                      else
                                                        InterestBorder.find_or_create_by_key(params[:interest_border])
                                                      end

    @groups = Group.look(params)
    respond_to do |format|
      format.html
      format.js {
        @disable_per_page = true
      }
    end
  end

  def show
    @group_posts = @group.post_publishings.
      accessible_by(current_ability).
      order('post_publishings.featured desc, blog_posts.published_at DESC, blog_posts.created_at DESC')

    respond_to do |format|
      format.html {
        if request.url.split('?')[0] != group_url(@group).split('?')[0]
          redirect_to group_url(@group), status: :moved_permanently
          return
        end
        @page_title = @group.name
        @group_participations = @group.participants
        @group_posts = @group_posts.page(params[:page]).per(COMMENTS_PER_PAGE)
        @archives = @group.blog_posts.select(' COUNT(*) AS posts, extract(month from blog_posts.created_at) AS MONTH, extract(year from blog_posts.created_at) AS YEAR ').group(' MONTH, YEAR ').order(' YEAR desc, extract(month from blog_posts.created_at) desc ')
        @last_topics = @group.topics.accessible_by(Ability.new(current_user), :index, false).includes(:views, :forum).order('frm_topics.created_at desc').limit(10)
        @next_events = @group.events.accessible_by(Ability.new(current_user), :index, false).next.order('starttime asc').limit(4)
      }
      format.js {
        @group_posts = @group_posts.page(params[:page]).per(COMMENTS_PER_PAGE)
      }
      format.atom
      format.json
    end
  end

  def by_year_and_month
    @group_posts = @group.post_publishings
                     .viewable_by(current_user)
                     .where(' extract(year from blog_posts.created_at) = ? AND extract(month from blog_posts.created_at) = ? ', params[:year], params[:month])
                     .order('post_publishings.featured desc, published_at DESC')
                     .select('post_publishings.*, published_at')
                     .uniq
                     .page(params[:page]).per(COMMENTS_PER_PAGE)

    respond_to do |format|
      format.html {
        @page_title = t('pages.groups.archives.title', group: @group.name, year: params[:year], month: t('calendar.monthNames')[params[:month].to_i - 1])
        @group_participations = @group.participants
        @archives = @group.blog_posts.select(' COUNT(*) AS posts, extract(month from blog_posts.created_at) AS MONTH, extract(year from blog_posts.created_at) AS YEAR ').group(' MONTH, YEAR ').order(' YEAR desc, extract(month from blog_posts.created_at) desc ')
        @last_topics = @group.topics.accessible_by(Ability.new(current_user)).includes(:views, :forum).order('frm_topics.created_at desc').limit(10)
        render 'show'
      }
      format.js {
        render 'show'
      }
      format.json { render 'show' }
    end
  end

  def new
    authorize! :create, Group
    @group = Group.new(accept_requests: 'p')
    @group.default_role_actions = DEFAULT_GROUP_ACTIONS
  end

  def edit
    authorize! :update, @group
    @page_title = t('pages.groups.edit.title')
  end

  def create
    @group.current_user_id = current_user.id
    if @group.save
      respond_to do |format|
        flash[:notice] = t('info.groups.group_created')
        format.html { redirect_to group_url(@group) }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.js { render 'layouts/active_record_error', locals: {object: @group} }
      end
    end
  end

  def update
    if @group.update(group_params)
      flash[:notice] = t('info.groups.group_updated')
      redirect_to edit_group_url @group
    else
      flash[:error] = t('error.groups.update')
      render action: ' edit '
    end
  end

  def destroy
    authorize! :destroy, @group
    @group.destroy
    flash[:notice] = t('info.groups.group_deleted')

    respond_to do |format|
      format.html { redirect_to(groups_url) }
    end
  end

  def ask_for_participation
    #verifica se l'utente ha già effettuato una richiesta di partecipazione a questo gruppo
    request = current_user.group_participation_requests.find_by(group_id: @group.id)
    if request #se non l'ha mai fatta
      flash[:notice] = t('info.group_participations.request_alredy_sent')
    else
      participation = @group.participants.include? current_user
      if participation #verifica se per caso non fa già parte del gruppo
        #crea una nuova richiesta di partecipazione ACCETTATA per correggere i dati
        request = GroupParticipationRequest.new
        request.user_id = current_user.id
        request.group_id = @group.id
        request.group_participation_request_status_id = 3 #accettata, dati corretti
        saved = request.save
        if saved
          flash[:error] = t('error.group_participations.request_not_registered')
        else
          flash[:notice] = t('error.group_participations.already_member')
        end
      else
        #inoltra la richiesta di partecipazione con stato IN ATTESA
        request = GroupParticipationRequest.new
        request.user_id = current_user.id
        request.group_id = @group.id
        request.group_participation_request_status_id = 1 #in attesa...
        saved = request.save
        if saved
          flash[:notice] = t('info.group_participations.request_sent')
        else
          flash[:error] = t('error.group_participations.request_sent')
        end
      end
    end
    redirect_to_back(group_path(@group))
  end

  def ask_for_multiple_follow
    Group.transaction do
      groups = params[:groupsi][:group_ids].split(';')
      number = 0
      groups.each do |group_id|
        group = Group.find(group_id)
        request = current_user.group_participation_requests.find_by(group_id: group.id)
        unless request #se non l'ha mai fatta
          participation = current_user.groups.find_by_id(group.id)
          if participation #verifica se per caso non fa già parte del gruppo
            #crea una nuova richiesta di partecipazione ACCETTATA per correggere i dati
            request = GroupParticipationRequest.new
            request.user_id = current_user.id
            request.group_id = group.id
            request.group_participation_request_status_id = 3 #accettata, dati corretti
            request.save!
          else
            #inoltra la richiesta di partecipazione con stato IN ATTESA
            request = GroupParticipationRequest.new
            request.user_id = current_user.id
            request.group_id = group.id
            request.group_participation_request_status_id = 1 #in attesa...
            request.save!
            number += 1
          end
        end
      end
      flash[:notice] = t('info.participation_request.multiple_request', count: number)
      redirect_to home_path
    end
  end

  def participation_request_confirm
    authorize! :accept_requests, @group
    @request = @group.participation_requests.pending.find(params[:request_id])

    if @group.request_by_portavoce?
      part = @group.group_participations.build(user: @request.user, acceptor: current_user, participation_role: @group.default_role)

      @request.group_participation_request_status_id = 3
    else
      @request.group_participation_request_status_id = 2
    end
    saved = part.save && @request.save
    if saved
      flash[:notice] = @group.request_by_portavoce? ? t('info.group_participations.status_accepted') : t('info.group_participations.status_voting')
      respond_to do |format|
        format.html { redirect_to group_url(@group) }
        format.js
      end
    else
      flash[:error] = t('error.group_participations.error_saving')
      respond_to do |format|
        format.html {
          redirect_to group_url(@group)
        }
        format.js { render :update do |page|
          page.replace_html ' flash_messages ', partial: 'layouts/flash', locals: {flash: flash}
        end
        }
      end
    end
  end

  def participation_request_decline
    authorize! :accept_requests, @group
    @request = @group.participation_requests.pending.find_by_id(params[:request_id])
    if !@request
      flash[:error] = t('error.group_participations.request_not_found')
      respond_to do |format|
        format.html {
          redirect_to group_url(@group)
        }
        format.js { render :update do |page|
          page.replace_html ' flash_messages ', partial: 'layouts/flash', locals: {flash: flash}
        end
        }
      end
    else
      if @group.request_by_portavoce?
        @request.group_participation_request_status_id = 4
      else
        @request.group_participation_request_status_id = 2
      end
      saved = @request.save
      if !saved
        flash[:error] = t('error.group_participations.error_saving')
        respond_to do |format|
          format.html {
            redirect_to group_url(@group)
          }
          format.js { render :update do |page|
            page.replace_html ' flash_messages ', partial: 'layouts/flash', locals: {flash: flash}
          end
          }
        end
      else
        if @group.request_by_portavoce?
          flash[:notice] = t('info.group_participations.status_declined')
        else
          flash[:notice] = t('info.group_participations.status_voting')
        end
        respond_to do |format|
          format.html {
            redirect_to group_url(@group)
          }
          format.js
        end
      end
    end
  end

  def change_advanced_options
    advanced_option = (params[:active] == 'true')
    @group.change_advanced_options = advanced_option
    if @group.save
      flash[:notice] = advanced_option ?
        t('info.quorums.can_modify_advanced_proposals_settings') :
        t('info.quorums.cannot_modify_advanced_proposals_settings')
      render 'layouts/success'
    else
      flash[:error] = t('error.quorums.advanced_proposals_settings')
      render 'layouts/error'
    end
  end

  def change_default_anonima
    default_anonima = (params[:active] == 'true')
    @group.default_anonima = default_anonima
    if @group.save
      flash[:notice] = default_anonima ?
        t('info.quorums.anonymous_proposals') :
        t('info.quorums.non_anonymous_proposals')
      render 'layouts/success'
    else
      flash[:error] = t('error.quorums.advanced_proposals_settings')
      render 'layouts/error'
    end
  end

  def change_default_visible_outside
    default_visible_outside = (params[:active] == 'true')
    @group.default_visible_outside = default_visible_outside
    if @group.save
      flash[:notice] = default_visible_outside ?
        t('info.quorums.public_proposals') :
        t('info.quorums.private_proposals')
      render 'layouts/success'
    else
      flash[:error] = t('error.quorums.advanced_proposals_settings')
      render 'layouts/error'
    end
  end

  def change_default_secret_vote
    default_secret_vote = (params[:active] == 'true')
    @group.default_secret_vote = default_secret_vote
    if @group.save
      flash[:notice] = default_secret_vote ?
        t('info.quorums.secret_vote') :
        t('info.quorums.non_secret_vote')
      render 'layouts/success'
    else
      flash[:error] = t('error.quorums.advanced_proposals_settings')
      render 'layouts/error'
    end
  end

  def reload_storage_size
  end

  def enable_areas
    @group.update_attribute(:enable_areas, true)
    redirect_to group_group_areas_url @group
  end

  def remove_post
    raise Exception unless (can? :remove_post, @group) || (can? :update, BlogPost.find(params[:post_id]))
    @publishing = @group.post_publishings.find_by_blog_post_id(params[:post_id])
    @publishing.destroy
    flash[:notice] = t('info.groups.post_removed')

  rescue Exception => e
    respond_to do |format|
      flash[:error] = t('error.groups.post_removed')
      format.js { render :update do |page|
        page.replace_html ' flash_messages ', partial: 'layouts/flash', locals: {flash: flash}
      end
      }
    end
  end

  def feature_post
    raise Exception unless (can? :remove_post, @group)
    publishing = @group.post_publishings.find_by(blog_post_id: params[:post_id])
    publishing.update(featured: !publishing.featured)
    flash[:notice] = t("info.groups.post_featured.#{publishing.featured}")
  end

  # retrieve the list of permission for the current user in the group
  def permissions_list
    @actions = @group.group_participations.find_by(user_id: current_user.id).participation_role.group_actions
  end

  protected

  def load_group
    @group = params[:id] ? Group.friendly.find(params[:id]) : Group.find_by!(subdomain: request.subdomain)
  end

  def group_params
    params[:group][:default_role_actions].reject!(&:empty?) if params[:group][:default_role_actions]
    params.require(:group).permit(:participant_tokens, :name, :description,
                                  :accept_requests, :facebook_page_url, :group_participations,
                                  :interest_border_tkn, :title_bar, :default_role_name,
                                  :image, :admin_title, :private, :rule_book, :tags_list,
                                  :change_advanced_options, :default_anonima, :default_visible_outside, :default_secret_vote,
                                  default_role_actions: [])
  end

  def render_404(exception=nil)
    #log_error(exception) if exception
    respond_to do |format|
      @title = I18n.t('error.error_404.groups.title')
      @message = I18n.t('error.error_404.groups.description')
      format.html { render 'errors/404', status: 404, layout: true }
    end
    true
  end

  private

  def choose_layout
    @group ? 'groups' : 'open_space'
  end
end
