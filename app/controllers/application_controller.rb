class ApplicationController < ActionController::Base
  include ApplicationHelper, StepsHelper
  helper :all

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: :render_error
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
    rescue_from ActionController::RoutingError, with: :render_404
    rescue_from ::AbstractController::ActionNotFound, with: :render_404
    rescue_from I18n::InvalidLocale, with: :invalid_locale
  end

  protect_from_forgery
  after_action :discard_flash_if_xhr

  before_action :store_location

  before_action :set_current_domain
  before_action :set_locale
  around_action :user_time_zone, if: :current_user

  before_action :load_tutorial

  skip_before_action :verify_authenticity_token, if: proc { |c| c.request.format == 'application/json' }

  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :is_admin?, :is_moderator?, :is_proprietary?, :current_url, :link_to_auth, :age, :is_group_admin?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :email, :name, :surname, :accept_conditions, :sys_locale_id, :password])
  end

  # redirect all'ultima pagina in cui ero
  def after_sign_in_path_for(resource)
    # se in sessione ho memorizzato un contributo, inseriscilo e mandami alla pagina della proposta
    if session[:proposal_comment] && session[:proposal_id]
      @proposal = Proposal.find(session[:proposal_id])
      params[:proposal_comment] = session[:proposal_comment].slice('content', 'parent_proposal_comment_id', 'section_id')
      session[:proposal_id] = nil
      session[:proposal_comment] = nil
      @proposal_comment = @proposal.proposal_comments.build(params[:proposal_comment])
      post_contribute # rescue nil
      proposal_path(@proposal)
    elsif session[:blog_comment] && session[:blog_post_id] && session[:blog_id]
      blog = Blog.friendly.find(session[:blog_id])
      blog_post = blog.blog_posts.find(session[:blog_post_id])
      blog_comment = blog_post.blog_comments.build(session[:blog_comment])

      session[:blog_id] = nil
      session[:blog_post_id] = nil
      session[:blog_comment] = nil
      if save_blog_comment(blog_comment)
        flash[:notice] = t('info.blog.comment_added')
      else
        flash[:error] = t('error.blog.comment_added')
      end
      blog_blog_post_path(blog, blog_post)
    else
      env = request.env
      ret = env['omniauth.origin'] || stored_location_for(resource) || root_path
      ret
    end
  end

  def save_blog_comment(blog_comment)
    blog_comment.user_id = current_user.id
    blog_comment.request = request
    blog_comment.save
  end

  # redirect alla pagina delle proposte
  def after_sign_up_path_for(_resource)
    proposals_path
  end

  protected

  # TODO: enable this also in tests
  def load_tutorial
    @step = get_next_step(current_user) if current_user && !Rails.env.test?
  end

  def ckeditor_filebrowser_scope(options = {})
    options = { assetable_id: current_user.id, assetable_type: 'User' }.merge(options)
    super
  end

  def load_group
    @group = Group.friendly.find(params[:group_id]) if params[:group_id].present?
  end

  def load_blog_data
    return unless @blog
    @user = @blog.user
    @blog_posts = @blog.blog_posts.includes(:user, :blog, :tags).page(params[:page]).per(COMMENTS_PER_PAGE)
    @recent_comments = @blog.comments.includes(:blog_post, user: [:image]).order('created_at DESC').limit(10)
    @recent_posts = @blog.blog_posts.published.limit(10)
    @archives = @blog.blog_posts.
                select('COUNT(*) AS posts, extract(month from created_at) AS MONTH , extract(year from created_at) AS YEAR').
                group('MONTH, YEAR').
                order(Arel.sql('YEAR desc, extract(month from created_at) desc'))
  end

  def extract_locale_from_tld
  end

  def set_current_domain
    @current_domain = if params[:l].present?
                        SysLocale.find_by_key(params[:l])
                      else
                        SysLocale.find_by(host: request.domain, lang: nil) || SysLocale.default
                      end
  end

  attr_reader :current_domain

  def current_territory
  end

  def set_locale
    @domain_locale = request.host.split('.').last
    @locale =
      if Rails.env.test? || Rails.env.development?
        params[:l].blank? ? I18n.default_locale : params[:l]
      else
        params[:l].blank? ? (current_domain.key || I18n.default_locale) : params[:l]
      end
    I18n.locale = @locale
  end

  def user_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end

  def default_url_options(_options = {})
    (!params[:l] || (params[:l] == @domain_locale)) ? {} : { l: I18n.locale }
  end

  def self.default_url_options(_options = {})
    { l: I18n.locale }
  end

  def log_error(exception)
    if SENTRY_ACTIVE && !Rails.env.test? && !Rails.env.development?
      extra = {}
      extra[:current_user_id] = current_user.id if current_user
      if exception.instance_of? CanCan::AccessDenied
        extra[:action] = exception.action.to_s
        extra[:subject] = exception.subject.class.class_name.to_s rescue nil
      end
      Appsignal.set_error(exception, extra: extra)
    else
      message = "\n#{exception.class} (#{exception.message}):\n"
      Rails.logger.error(message)
      Rails.logger.error exception.backtrace.join("\n")
    end
  end

  def render_error(exception)
    log_error(exception)
    respond_to do |format|
      format.js do
        flash.now[:error] = "<b>#{t('error.error_500.title')}</b></br>#{t('error.error_500.description')}"
        render template: 'layouts/error', status: 500, layout: 'application'
      end
      format.html do
        render template: '/errors/500.html.erb', status: 500, layout: 'application'
      end
    end
  end

  def invalid_locale(exception)
    locales_replacement = { en: :'en-EU',
                            zh: :'zh-TW',
                            ru: :'ru-RU',
                            fr: :'fr-FR',
                            pt: :'pt-PT',
                            hu: :'hu-HU',
                            el: :'el-GR',
                            de: :'de-DE' }.with_indifferent_access
    required_locale = params[:l]
    replacement_locale = locales_replacement[required_locale]
    if replacement_locale
      redirect_to url_for(params.merge(l: replacement_locale).merge(only_path: true)), status: :moved_permanently
    else
      log_error(exception)
      respond_to do |format|
        format.js do
          flash.now[:error] = 'You are asking for a locale which is not available, sorry'
          render template: '/errors/invalid_locale.js.erb', status: 500, layout: 'application'
        end
        format.html do
          render template: '/errors/invalid_locale.html.erb', status: 500, layout: 'application'
        end
        log_error(exception)
        respond_to do |format|
          format.js do
          end
          format.html do
          end
        end
      end
    end
  end

  def render_404(exception = nil)
    log_error(exception) if exception
    respond_to do |format|
      format.js do
        flash.now[:error] = 'Page not available.'
        render template: '/errors/invalid_locale.js.erb', status: 404, layout: 'application'
      end
      format.html { render 'errors/404', status: 404, layout: 'application' }
    end
  end

  # TODO: avoid permit!
  def current_url(overwrite = {})
    url_for params.permit!.to_h.merge(overwrite).merge(only_path: false)
  end

  # helper method per determinare se l'utente attualmente collegato è amministratore di sistema
  def is_admin?
    user_signed_in? && current_user.admin?
  end

  # helper method per determinare se l'utente attualmente collegato è amministratore di gruppo
  def is_group_admin?(group)
    (current_user && (group.portavoce.include? current_user)) || is_admin?
  end

  # helper method per determinare se l'utente attualmente collegato è amministratore di sistema
  def is_moderator?
    user_signed_in? && current_user.moderator?
  end

  # helper method per determinare se l'utente attualmente collegato è il proprietario di un determinato oggetto
  def is_proprietary?(object)
    current_user && current_user.is_mine?(object)
  end

  def age(birthdate)
    today = Date.today
    # Difference in years, less one if you have not had a birthday this year.
    a = today.year - birthdate.year
    a -= 1 if birthdate.month > today.month || (birthdate.month >= today.month && birthdate.day > today.day)
    a
  end

  def link_to_auth(_text, _link)
    '<a>login</a>'
  end

  def title(ttl)
    @page_title = ttl
  end

  def admin_required
    is_admin? || admin_denied
  end

  def moderator_required
    is_admin? || is_moderator? || admin_denied
  end

  # response if you must be an administrator
  def admin_denied
    respond_to do |format|
      format.js do # se era una chiamata ajax, mostra il messaggio
        flash.now[:error] = t('error.admin_required')
        render 'layouts/error'
      end
      format.html do # ritorna indietro oppure all'HomePage
        store_location
        flash[:error] = t('error.admin_required')
        redirect_back(fallback_location: proposals_path)
      end
    end
  end

  def redirect_to_back(path)
    redirect_back(fallback_location: path)
  end

  # response if you do not have permissions to do an action
  def permissions_denied(exception = nil)
    respond_to do |format|
      format.js do # se era una chiamata ajax, mostra il messaggio
        if current_user
          log_error(exception)
          flash.now[:error] = exception.message
          render 'layouts/error', status: :forbidden
        else
          render 'layouts/authenticate'
        end
      end
      format.html do # ritorna indietro oppure all'HomePage
        if current_user
          log_error(exception)
          flash[:error] = exception.message
          render 'errors/access_denied', status: :forbidden
        else
          redirect_to new_user_session_path
        end
      end
      format.all do
        log_error(exception)
        render text: 'Permission denied', status: :forbidden
      end
    end
  end

  # persist in session the last visited url
  def store_location
    return if skip_store_location?
    session[:proposal_id] = nil
    session[:proposal_comment] = nil
    session[:user_return_to] = request.url
  end

  def skip_store_location?
    request.xhr? || !params[:controller] || !request.get? ||
      (params[:controller].starts_with? 'devise/') ||
      (params[:controller] == 'passwords') ||
      (params[:controller] == 'sessions') ||
      (params[:controller] == 'users/omniauth_callbacks') ||
      (params[:controller] == 'alerts' && params[:action] == 'index') ||
      (params[:controller] == 'users' && (%w(join_accounts confirm_credentials).include? params[:action])) ||
      (params[:action] == 'feedback')
  end

  def post_contribute
    ProposalComment.transaction do
      @proposal_comment.user_id = current_user.id
      @proposal_comment.request = request
      @proposal_comment.save!
      @ranking = ProposalCommentRanking.new
      @ranking.user_id = current_user.id
      @ranking.proposal_comment_id = @proposal_comment.id
      @ranking.ranking_type_id = :positive
      @ranking.save!

      @generated_nickname = @proposal_comment.nickname_generated

      if @proposal_comment.is_contribute?
        # if it's lateral show a message, else show show another message
        if @proposal_comment.paragraph
          @section = @proposal_comment.paragraph.section
          flash[:notice] = if params[:right]
                             t('info.proposal.contribute_added')
                           else
                             t('info.proposal.contribute_added_right', section: @section.title)
                           end
        else
          flash[:notice] = t('info.proposal.contribute_added')
        end
      else
        flash[:notice] = t('info.proposal.comment_added')
      end
    end
  end

  def discard_flash_if_xhr
    flash.discard if request.xhr?
  end

  rescue_from CanCan::AccessDenied do |exception|
    permissions_denied(exception)
  end

  # check as rode all the alerts of the page.
  # it's a generic method but with a per-page solution
  # call it in an after_action
  def check_page_alerts
    return unless current_user
    case params[:controller]
    when 'proposals'
      case params[:action]
      when 'show'
        # mark as checked all user alerts about this proposal
        @unread = current_user.alerts.joins(:notification).where(["(notifications.properties -> 'proposal_id') = ? and alerts.checked = ?", @proposal.id.to_s, false])
        if @unread.where(['notifications.notification_type_id = ?', NotificationType::AVAILABLE_AUTHOR]).exists?
          flash[:info] = t('info.proposal.available_authors')
        end
        @unread.check_all
      end
    when 'blog_posts'
      case params[:action]
      when 'show'
        # mark as checked all user alerts about this proposal
        @unread = current_user.alerts.joins(:notification).where(["(notifications.properties -> 'blog_post_id') = ? and alerts.checked = ?", @blog_post.id.to_s, false])
        @unread.check_all
      end
    end
  end

  private

  def forem_admin?(group)
    can? :update, group
  end

  helper_method :forem_admin?

  def forem_admin_or_moderator?(forum)
    can? :update, forum.group || forum.moderator?(current_user)
  end

  helper_method :forem_admin_or_moderator?

  def redirect_url(proposal)
    proposal.private? ? group_proposal_url(proposal.groups.first, proposal) : proposal_url(proposal)
  end
end
