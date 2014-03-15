#encoding: utf-8
class GroupsController < ApplicationController
  include NotificationHelper, GroupsHelper

  layout :choose_layout
  #carica il gruppo
  before_filter :load_group, :except => [:index, :new, :create, :ask_for_multiple_follow]

  ###SICUREZZA###

  #l'utente deve aver fatto login
  before_filter :authenticate_user!, :except => [:index, :show, :by_year_and_month]

  #before_filter :check_author,   :only => [:new, :create, :edit, :update, :destroy]

  #l'utente deve essere portavoce o amministratore
  before_filter :portavoce_required, :only => [:edit, :update, :edit_permissions, :enable_areas, :edit_proposals]

  before_filter :admin_required, :only => [:autocomplete]


  def autocomplete
    groups = Group.autocomplete(params[:term])
    groups = groups.map do |u|
      {:id => u.id, :identifier => "#{u.name}", :image_path => "#{u.group_image_tag 20}"}
    end
    render :json => groups
  end


  def index
    unless request.xhr?
      @tags = Tag.most_groups.shuffle
    end

    interest_border_key = params[:interest_border]
    if interest_border_key.to_s != ''
      ftype = interest_border_key[0, 1] #tipologia (primo carattere)
      fid = interest_border_key[2..-1] #chiave primaria (dal terzo all'ultimo carattere)
      @interest_border = InterestBorder.find_by_territory_type_and_territory_id(InterestBorder::I_TYPE_MAP[ftype], fid)
    end
    params[:interest_border_obj] = @interest_border

    @groups = Group.look(params)
    respond_to do |format|
      format.js
      format.html
      #format.xml  { render :xml => @groups }
    end
  end

  def show
    if current_user
      @group_posts = @group.post_publishings.viewable_by(current_user).order('post_publishings.featured desc, published_at DESC').select('post_publishings.*, published_at').uniq
    else
      @group_posts = @group.posts.published.includes([:blog, {:user => :image}, :tags]).order('post_publishings.featured desc, published_at DESC')
    end

    respond_to do |format|
      format.js {
        @group_posts = @group_posts.page(params[:page]).per(COMMENTS_PER_PAGE)
      }
      format.html {
        if request.url.split('?')[0] != group_url(@group)
          redirect_to group_url(@group), status: :moved_permanently
          return
        end
        @page_title = @group.name
        @partecipants = @group.partecipants
        @group_posts = @group_posts.page(params[:page]).per(COMMENTS_PER_PAGE)
        @archives = @group.posts.select("COUNT(*) AS posts, extract(month from blog_posts.created_at) AS MONTH , extract(year from blog_posts.created_at) AS YEAR").group("MONTH, YEAR").order("YEAR desc, extract(month from blog_posts.created_at) desc")
      }
      format.atom
      format.json
    end
  end


  def by_year_and_month
    if current_user
      @group_posts = @group.post_publishings.viewable_by(current_user).order('post_publishings.featured desc, published_at DESC').select('post_publishings.*, published_at').uniq
    else
      @group_posts = @group.posts.published.includes([:blog, {:user => :image}, :tags]).order('post_publishings.featured desc, published_at DESC')
    end
    @group_posts = @group_posts.where("extract(year from blog_posts.created_at) = ? AND extract(month from blog_posts.created_at) = ? ", params[:year], params[:month])

    respond_to do |format|
      format.js {
        @group_posts = @group_posts.page(params[:page]).per(COMMENTS_PER_PAGE)
        render 'show'
      }
      format.html {
        @page_title = t('pages.groups.archives.title', group: @group.name, year: params[:year], month: t('date.month_names')[params[:month].to_i])
        @partecipants = @group.partecipants
        @group_posts = @group_posts.page(params[:page]).per(COMMENTS_PER_PAGE)
        @archives = @group.posts.select("COUNT(*) AS posts, extract(month from blog_posts.created_at) AS MONTH , extract(year from blog_posts.created_at) AS YEAR").group("MONTH, YEAR").order("YEAR desc, extract(month from blog_posts.created_at) desc")
        render 'show'
      }
      format.json {render 'show'}
    end
  end


  def new
    authorize! :create, Group
    @group = Group.new(:accept_requests => 'p')
    @group.default_role_actions = DEFAULT_GROUP_ACTIONS

    respond_to do |format|
      format.html # new.html.erb
      format.xml { render :xml => @group }
    end
  end

  def edit
    authorize! :update, @group
    @page_title = t("pages.groups.edit.title")
  end


  def edit_events
    @page_title = t("pages.groups.edit_events.title")
  end

  def edit_permissions
    @page_title = t("pages.groups.edit_permissions.title")
  end

  def edit_proposals
    #conta il numero di partecipanti che possono valutare le proposte
  end

  def change_advanced_options
    advanced_options = params[:active]
    @group.change_advanced_options = advanced_options
    @group.save
    if (advanced_options == 'true')
      flash[:notice] = t('info.quorums.can_modify_advanced_proposals_settings')
    else
      flash[:notice] = t('info.quorums.cannot_modify_advanced_proposals_settings')
    end

    respond_to do |format|
      format.js { render :update do |page|
        page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
      end
      }
    end

  rescue Exception => e
    respond_to do |format|
      flash[:error] = t('error.quorums.advanced_proposals_settings')
      format.js { render :update do |page|
        page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
      end
      }
    end
  end


  def change_default_anonima
    default_anonima = params[:active]
    @group.default_anonima = default_anonima
    @group.save
    if (default_anonima == 'true')
      flash[:notice] = t('info.quorums.anonymous_proposals')
    else
      flash[:notice] = t('info.quorums.non_anonymous_proposals')
    end

    respond_to do |format|
      format.js { render :update do |page|
        page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
      end
      }
    end

  rescue Exception => e
    respond_to do |format|
      flash[:error] = t('error.quorums.advanced_proposals_settings')
      format.js { render :update do |page|
        page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
      end
      }
    end
  end

  #change the default option in a group for the public proposals
  def change_default_visible_outside
    default_visible_outside = params[:active]
    @group.default_visible_outside = default_visible_outside
    @group.save
    if (default_visible_outside == 'true')
      flash[:notice] = t('info.quorums.public_proposals')
    else
      flash[:notice] = t('info.quorums.private_proposals')
    end

    respond_to do |format|
      format.js { render :update do |page|
        page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
      end
      }
    end

  rescue Exception => e
    respond_to do |format|
      flash[:error] = t('error.quorums.advanced_proposals_settings')
      format.js { render :update do |page|
        page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
      end
      }
    end
  end

  #change the default option in a group for the secret vote
  def change_default_secret_vote
    default_secret_vote = params[:active]
    @group.default_secret_vote = default_secret_vote
    @group.save
    if default_secret_vote == 'true'
      flash[:notice] = t('info.quorums.secret_vote')
    else
      flash[:notice] = t('info.quorums.non_secret_vote')
    end

    respond_to do |format|
      format.js { render :update do |page|
        page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
      end
      }
    end

  rescue Exception => e
    respond_to do |format|
      flash[:error] = t('error.quorums.advanced_proposals_settings')
      format.js { render :update do |page|
        page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
      end
      }
    end
  end

  #crea un nuovo gruppo
  def create
    authorize! :create, Group
    begin
      Group.transaction do

        params[:group][:default_role_actions].reject!(&:empty?)

        @group = Group.new(params[:group]) #crea il gruppo
        @group.current_user_id = current_user.id
        @group.save!
        Dir.mkdir "#{Rails.root}/private/elfinder/#{@group.id}"
      end
      respond_to do |format|
        flash[:notice] = t('info.groups.group_created')
        format.html { redirect_to group_url(@group) }
        #format.xml  { render :xml => @group, :status => :created, :location => @group }
      end #respond_to

    rescue ActiveRecord::ActiveRecordError => e
      respond_to do |format|
        flash[:error] = t('error.groups.creation')
        format.html { render :action => "new" }
      end
    end #begin
  end

  #create

  def update
    authorize! :update, @group
    begin
      Group.transaction do

        @group.attributes = params[:group]

        if @group.name_changed?
          @group.internal_proposals.each do |proposal|
            proposal.update_column(:url, group_proposal_path(@group, proposal))
          end
        end


        partecipant_ids = @group.partecipant_ids
        partecipant_ids.each do |id|
          r = GroupPartecipationRequest.new({:group_id => @group.id, :user_id => id, :group_partecipation_request_status_id => 3})
          r.save
        end

        @group.save!
      end

      respond_to do |format|
        flash[:notice] = t('info.groups.group_updated')
        format.html { render :action => "edit" }
      end

    rescue Exception => e
      puts e
      respond_to do |format|
        flash[:error] = t('error.groups.update')
        format.html { render :action => "edit" }
      end
    end
  end


  def destroy
    authorize! :destroy, @group
    @group.destroy
    flash[:notice] = t('info.groups.group_deleted')

    respond_to do |format|
      format.html { redirect_to(groups_url) }
      #format.xml  { head :ok }
    end
  end

  #fa partire una richiesta per la partecipazione dell'utente corrente al gruppo
  def ask_for_partecipation
    #verifica se l'utente ha già effettuato una richiesta di partecipazione a questo gruppo
    request = current_user.group_partecipation_requests.find_by_group_id(@group.id)

    if (!request) #se non l'ha mai fatta
      partecipation = current_user.groups.find_by_id(@group.id)
      if (partecipation) #verifica se per caso non fa già parte del gruppo
                         #crea una nuova richiesta di partecipazione ACCETTATA per correggere i dati
        request = GroupPartecipationRequest.new
        request.user_id = current_user.id
        request.group_id = @group.id
        request.group_partecipation_request_status_id = 3 #accettata, dati corretti
        saved = request.save
        if (!saved)
          flash[:notice] = t('error.group_partecipations.already_member')
        else
          flash[:error] = t('error.group_partecipations.request_not_registered')
        end
      else
        #inoltra la richiesta di partecipazione con stato IN ATTESA
        request = GroupPartecipationRequest.new
        request.user_id = current_user.id
        request.group_id = @group.id
        request.group_partecipation_request_status_id = 1 #in attesa...
        saved = request.save
        if (!saved)
          flash[:error] = t('error.group_partecipations.request_sent')
        else
          flash[:notice] = t('info.group_partecipations.request_sent')
          notify_user_asked_for_partecipation(@group) #invia notifica ai portavoce
        end
      end
    else
      flash[:notice] = t('info.group_partecipations.request_alredy_sent')

    end
    redirect_to group_url(@group)
  end

  #fa partire una richiesta per seguire il gruppo
  def ask_for_follow
    #verifica se l'utente stà già seguendo questo gruppo
    follow = current_user.group_follows.find_by_group_id(@group.id)

    if (!follow) #se non lo segue
                 #segui il gruppo
      follow = current_user.group_follows.build(:group_id => @group.id)

      saved = follow.save
      if (!saved)
        flash[:error] = 'Errore nella procedura per seguire il gruppo. Spiacenti!'
      else
        flash[:notice] = 'Ora segui questo gruppo'
      end
    else
      flash[:error] = 'Stai già seguendo questo gruppo'
    end
    redirect_to group_url(@group)
  end

  #fa partire una richiesta di partecipazione a ciascun gruppo
  def ask_for_multiple_follow
    Group.transaction do
      groups = params[:groupsi][:group_ids].split(';')
      number = 0
      groups.each do |group_id|
        group = Group.find(group_id)
        request = current_user.group_partecipation_requests.find_by_group_id(group.id)
        unless request #se non l'ha mai fatta
          partecipation = current_user.groups.find_by_id(group.id)
          if partecipation #verifica se per caso non fa già parte del gruppo
                           #crea una nuova richiesta di partecipazione ACCETTATA per correggere i dati
            request = GroupPartecipationRequest.new
            request.user_id = current_user.id
            request.group_id = group.id
            request.group_partecipation_request_status_id = 3 #accettata, dati corretti
            request.save!
          else
            #inoltra la richiesta di partecipazione con stato IN ATTESA
            request = GroupPartecipationRequest.new
            request.user_id = current_user.id
            request.group_id = group.id
            request.group_partecipation_request_status_id = 1 #in attesa...
            request.save!
            notify_user_asked_for_partecipation(group) #invia notifica ai portavoce
            number += 1
          end
        end
      end
      flash[:notice] = t('info.participation_request.multiple_request', count: number)
      redirect_to home_path
    end

  end


  #accetta una richiesta di partecipazione passandola allo stato IN VOTAZIONE se
  # è previsto o accettandola altrimenti.
  def partecipation_request_confirm
    authorize! :accept_requests, @group
    @request = @group.partecipation_requests.pending.find_by_id(params[:request_id])
    if !@request
      flash[:error] = t('error.group_partecipations.request_not_found')
      respond_to do |format|
        format.js { render :update do |page|
          page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
        end
        }
        format.html {
          redirect_to group_url(@group)
        }
      end
    else
      if @group.request_by_portavoce?
        part = GroupPartecipation.new
        part.user_id = @request.user_id
        part.group_id = @group.id
        part.acceptor_id = current_user.id
        part.partecipation_role_id = @group.partecipation_role_id
        part.save!
        @request.group_partecipation_request_status_id = 3
      else
        @request.group_partecipation_request_status_id = 2
      end
      saved = @request.save
      if !saved
        flash[:error] = t('error.group_partecipations.error_saving')
        respond_to do |format|
          format.js { render :update do |page|
            page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
          end
          }
          format.html {
            redirect_to group_url(@group)
          }
        end
      else
        if @group.request_by_portavoce?
          flash[:notice] = t('info.group_partecipations.status_accepted')
        else
          flash[:notice] = t('info.group_partecipations.status_voting')
        end
        respond_to do |format|
          format.js
          format.html {
            redirect_to group_url(@group)
          }
        end
      end
    end
  end

  def partecipation_request_decline
    authorize! :accept_requests, @group
    @request = @group.partecipation_requests.pending.find_by_id(params[:request_id])
    if !@request
      flash[:error] = t('error.group_partecipations.request_not_found')
      respond_to do |format|
        format.js { render :update do |page|
          page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
        end
        }
        format.html {
          redirect_to group_url(@group)
        }
      end
    else
      if @group.request_by_portavoce?
        @request.group_partecipation_request_status_id = 4
      else
        @request.group_partecipation_request_status_id = 2
      end
      saved = @request.save
      if !saved
        flash[:error] = t('error.group_partecipations.error_saving')
        respond_to do |format|
          format.js { render :update do |page|
            page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
          end
          }
          format.html {
            redirect_to group_url(@group)
          }
        end
      else
        if @group.request_by_portavoce?
          flash[:notice] = t('info.group_partecipations.status_declined')
        else
          flash[:notice] = t('info.group_partecipations.status_voting')
        end
        respond_to do |format|
          format.js
          format.html {
            redirect_to group_url(@group)
          }
        end
      end
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
        page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
      end
      }
    end
  end

  def feature_post
    raise Exception unless (can? :remove_post, @group)
    @publishing = @group.post_publishings.find_by({blog_post_id: params[:post_id]})
    @publishing.update_attributes({featured: !@publishing.featured})
    flash[:notice] = t('info.groups.post_featured')

  rescue Exception => e
    respond_to do |format|
      flash[:error] = t('error.groups.post_featured')
      format.js {render 'layouts/error'}
    end
  end

  #retrieve the list of permission for the current user in the group
  def permissions_list
    @actions = @group.group_partecipations.find_by_user_id(current_user.id).partecipation_role.group_actions
  end


  protected

  def load_group
    @group = params[:id] ? Group.friendly.find(params[:id]) : Group.find_by_subdomain(request.subdomain)
  end

  def portavoce_required
    unless (current_user && (@group.portavoce.include? current_user)) || is_admin?
      flash[:error] = t('error.portavoce_required')
      redirect_to group_url(@group)
    end
  end

  def render_404(exception=nil)
    #log_error(exception) if exception
    respond_to do |format|
      @title = I18n.t('error.error_404.groups.title')
      @message = I18n.t('error.error_404.groups.description')
      format.html { render "errors/404", :status => 404, :layout => true }
    end
    true
  end

  private

  def choose_layout
    @group ? 'groups' : 'open_space'
  end

end







