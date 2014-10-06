#encoding: utf-8
class ApplicationController < ActionController::Base
  include ApplicationHelper, GroupsHelper, NotificationHelper, StepsHelper
  helper :all
  protect_from_forgery
  after_filter :discard_flash_if_xhr

  before_filter :store_location

  before_filter :set_locale
  around_filter :user_time_zone, if: :current_user


  before_filter :load_tutorial

  skip_before_filter :verify_authenticity_token, if: Proc.new { |c| c.request.format == 'application/json' }

  before_filter :configure_permitted_parameters, if: :devise_controller?

  helper_method :is_admin?, :is_moderator?, :is_proprietary?, :current_url, :link_to_auth, :age, :is_group_admin?, :in_subdomain?


  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :name, :surname, :accept_conditions, :sys_locale_id, :password) }
  end

  #redirect all'ultima pagina in cui ero
  def after_sign_in_path_for(resource)
    #se in sessione ho memorizzato un contributo, inseriscilo e mandami alla pagina della proposta
    if session[:proposal_comment] && session[:proposal_id]
      @proposal = Proposal.find(session[:proposal_id])
      params[:proposal_comment] = session[:proposal_comment].permit(:content, :parent_proposal_comment_id, :section_id)
      session[:proposal_id] = nil
      session[:proposal_comment] = nil
      @proposal_comment = @proposal.proposal_comments.build(params[:proposal_comment])
      post_contribute #rescue nil
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

  #redirect alla pagina delle proposte
  def after_sign_up_path_for(resource)
    proposals_path
  end

  protected

  def load_tutorial
    @step = get_next_step(current_user) if (current_user && !Rails.env.test?)
  end

  def ckeditor_filebrowser_scope(options = {})
    options = {assetable_id: current_user.id, assetable_type: 'User'}.merge(options)
    super
  end


  def load_group
    if params[:group_id].to_s != ''
      @group = Group.friendly.find(params[:group_id])
    elsif !['', 'www'].include? request.subdomain
      @group = Group.find_by(subdomain: request.subdomain)
    end
    @group
  end


  def load_blog_data
    if @blog
      @user = @blog.user
      @blog_posts = @blog.blog_posts.published.includes(:user, :blog, :tags).page(params[:page]).per(COMMENTS_PER_PAGE)
      @recent_comments = @blog.comments.includes(:blog_post, user: [:image, :user_type]).order('created_at DESC').limit(10)
      @recent_posts = @blog.blog_posts.published.limit(10)
      @archives = @blog.blog_posts.select("COUNT(*) AS posts, extract(month from created_at) AS MONTH , extract(year from created_at) AS YEAR").group("MONTH, YEAR").order("YEAR desc, extract(month from created_at) desc")
    end
  end

  def extract_locale_from_tld
  end

  def set_locale
    @domain_locale = request.host.split('.').last
    params[:l] = SysLocale.find_by_key(params[:l]) ? params[:l] : nil
    @locale =
        if Rails.env.staging?
          params[:l] || I18n.default_locale
        elsif Rails.env.test?
          params[:l] || I18n.default_locale
        else
          params[:l] || @domain_locale || I18n.default_locale
        end
    @locale = 'en' if ['en', 'eu'].include? @locale
    @locale = 'en-US' if ['us'].include? @locale
    @locale = 'zh' if ['cn'].include? @locale
    @locale = 'it-IT' if ['it', 'org', 'net'].include? @locale
    I18n.locale = @locale
  end

  def user_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end

  def default_url_options(options={})
    (!params[:l] || (params[:l] == @domain_locale)) ? {} : {l: I18n.locale}
  end

  def self.default_url_options(options={})
    {l: I18n.locale}
  end


  def log_error(exception)
    notifier = Rails.application.config.middleware.detect { |x| x.klass == ExceptionNotifier }
    if notifier
      env = request.env
      env['exception_notifier.options'] = notifier.args.first || {}
      ExceptionNotifier.notify_exception(exception, env).deliver
      env['exception_notifier.delivered'] = true
      message = "\n#{exception.class} (#{exception.message}):\n"
      Rails.logger.error(message)
    else
      Rails.logger.error exception.backtrace.join("\n")
    end
  end


  def render_error(exception)
    log_error(exception)
    respond_to do |format|
      format.js {
        flash.now[:error] = "<b>#{t('error.error_500.title')}</b></br>#{t('error.error_500.description')}"
        render template: "layouts/error", status: 500, layout: 'application'
      }
      format.html {
        render template: "/errors/500.html.erb", status: 500, layout: 'application'
      }
    end

  end

  def solr_unavailable(exception)
    log_error(exception)
    respond_to do |format|
      format.js {
        flash.now[:error] = 'Sorry. Service unavailable. Try again in few minutes.'
        render template: "/errors/solr_unavailable.js.erb", status: 500, layout: 'application'
      }
      format.html {
        render template: "/errors/solr_unavailable.html.erb", status: 500, layout: 'application'
      }
    end
  end

  def render_404(exception=nil)
    log_error(exception) if exception
    respond_to do |format|
      format.js {
        flash.now[:error] = 'Sorry. Service unavailable. Try again in few minutes.'
        render template: "/errors/solr_unavailable.js.erb", status: 500, layout: 'application'
      }
      format.html { render "errors/404", status: 404, layout: 'application' }
    end
  end

  def current_url(overwrite={})
    url_for params.merge(overwrite).merge(only_path: false)
  end

  #helper method per determinare se l'utente attualmente collegato è amministratore di sistema
  def is_admin?
    user_signed_in? && current_user.admin?
  end

  #helper method per determinare se l'utente attualmente collegato è amministratore di gruppo
  def is_group_admin?(group)
    (current_user && (group.portavoce.include? current_user)) || is_admin?
  end

  #helper method per determinare se l'utente attualmente collegato è amministratore di sistema
  def is_moderator?
    user_signed_in? && current_user.moderator?
  end

  #helper method per determinare se l'utente attualmente collegato è il proprietario di un determinato oggetto
  def is_proprietary?(object)
    current_user && current_user.is_mine?(object)
  end

  def age(birthdate)
    today = Date.today
    puts 'today: ' + today.to_s
    # Difference in years, less one if you have not had a birthday this year.
    a = today.year - birthdate.year
    a = a - 1 if (
    birthdate.month > today.month or
        (birthdate.month >= today.month and birthdate.day > today.day)
    )
    a
  end


  def link_to_auth (text, link)
    "<a>login</a>"
  end

  def title(ttl)
    @page_title = ttl
  end


  def admin_required
    is_admin? || admin_denied
  end

  def moderator_required
    is_admin? ||is_moderator? || admin_denied
  end

  def in_subdomain?
    request.subdomain.present? && request.subdomain != 'www'
  end

  #response if you must be an administrator
  def admin_denied
    respond_to do |format|
      format.js do #se era una chiamata ajax, mostra il messaggio
        flash.now[:error] = t('error.admin_required')
        render 'layouts/error'
      end
      format.html do #ritorna indietro oppure all'HomePage
        store_location
        flash[:error] = t('error.admin_required')
        if request.env["HTTP_REFERER"]
          redirect_to :back
        else
          redirect_to proposals_path
        end
      end
    end
  end

  #response if you do not have permissions to do an action
  def permissions_denied(exception=nil)
    respond_to do |format|
      format.js do #se era una chiamata ajax, mostra il messaggio

        if current_user
          flash.now[:error] = exception.message
          render 'layouts/error', status: :forbidden
        else
          render 'layouts/authenticate'
        end
      end
      format.html do #ritorna indietro oppure all'HomePage
        if current_user
          flash[:error] = exception.message
          render 'errors/access_denied', status: :forbidden
        else
          redirect_to new_user_session_path
        end
      end
    end
  end

  #salva l'url
  def store_location
    unless (request.xhr? ||
        (!params[:controller]) ||
        (params[:controller].starts_with? "devise/") ||
        (params[:controller] == "passwords") ||
        (params[:controller] == "sessions") ||
        (params[:controller] == "users/omniauth_callbacks") ||
        (params[:controller] == "alerts" && params[:action] == "index") ||
        (params[:controller] == "users" && (params[:action] == "join_accounts" || params[:action] == "confirm_credentials")) ||
        (params[:action] == 'feedback') || !request.get?)
      session[:proposal_id] = nil
      session[:proposal_comment] = nil
      session[:user_return_to] = request.url
    end
  end


  def post_contribute
    ProposalComment.transaction do
      @proposal_comment.user_id = current_user.id
      @proposal_comment.request = request
      @proposal_comment.save!
      @ranking = ProposalCommentRanking.new
      @ranking.user_id = current_user.id
      @ranking.proposal_comment_id = @proposal_comment.id
      @ranking.ranking_type_id = RankingType::POSITIVE
      @ranking.save!

      generate_nickname(current_user, @proposal)

      if @proposal_comment.is_contribute?

        if @proposal_comment.paragraph
          @section = @proposal_comment.paragraph.section
          if params[:right]
            flash[:notice] = t('info.proposal.contribute_added')
          else
            flash[:notice] = t('info.proposal.contribute_added_right', {section: @section.title})
          end
        else
          flash[:notice] = t('info.proposal.contribute_added')
        end
      else
        flash[:notice] = t('info.proposal.comment_added')
      end
      #if it's lateral show a message, else show show another message

    end
  end

  def generate_nickname(user, proposal)
    nickname = ProposalNickname.find_by_user_id_and_proposal_id(user.id, proposal.id)
    unless nickname
      loop = true
      while loop do
        nickname = NicknameGeneratorHelper.give_me_a_nickname
        loop = ProposalNickname.find_by_proposal_id_and_nickname(proposal.id, nickname)
      end
      ProposalNickname.create(user_id: user.id, proposal_id: proposal.id, nickname: nickname)

      @generated_nickname = @proposal.is_anonima?
    end
  end


  def discard_flash_if_xhr
    flash.discard if request.xhr?
  end

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: :render_error
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
    rescue_from ActionController::RoutingError, with: :render_404
    rescue_from ActionController::UnknownController, with: :render_404
    rescue_from ::AbstractController::ActionNotFound, with: :render_404
    rescue_from Errno::ECONNREFUSED, with: :solr_unavailable
  end

  rescue_from CanCan::AccessDenied do |exception|
    permissions_denied(exception)
  end

  #check as rode all the alerts of the page.
  #it's a generic method but with a per-page solution
  #call it in an after_filter
  def check_page_alerts
    if current_user
      case params[:controller]
        when 'proposals'
          case params[:action]
            when 'show'
              #mark as checked all user alerts about this proposal
              @unread = current_user.alerts.joins(:notification).where(["(notifications.properties -> 'proposal_id') = ? and alerts.checked = ?", @proposal.id.to_s, false])
              if @unread.where(['notifications.notification_type_id = ?', NotificationType::AVAILABLE_AUTHOR]).exists?
                flash[:info] = t('info.proposal.available_authors')
              end
              @unread.check_all
              @not_count = ProposalAlert.find_by_user_id_and_proposal_id(current_user.id, @proposal.id)
              @not_count.update_attribute(:count, 0) if @not_count #just to be sure. if everything is correct this would not be required but what if not?...just leave it here
            else
          end
        when 'blog_posts'
          case params[:action]
            when 'show'
              #mark as checked all user alerts about this proposal
              @unread = current_user.alerts.joins(:notification).where(["(notifications.properties -> 'blog_post_id') = ? and alerts.checked = ?", @blog_post.id.to_s, false])
              @unread.check_all
            else
          end
        else
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
