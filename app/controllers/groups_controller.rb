#encoding: utf-8
class GroupsController < ApplicationController
  include NotificationHelper

  layout :choose_layout
  #carica il gruppo
  before_filter :load_group, :except => [:index, :new, :create, :ask_for_multiple_follow]

  ###SICUREZZA###

  #l'utente deve aver fatto login
  before_filter :authenticate_user!, :except => [:index, :show, :partecipants_list_panel]

  #before_filter :check_author,   :only => [:new, :create, :edit, :update, :destroy]

  #l'utente deve essere amministratore
  before_filter :admin_required, :only => [:destroy]

  #l'utente deve essere portavoce o amministratore
  before_filter :portavoce_required, :only => [:edit, :update, :edit_permissions, :enable_areas, :remove_post]

  def index
    @groups = Group.look(params[:search], params[:page])
    respond_to do |format|
      format.js
      format.html
      #format.xml  { render :xml => @groups }
    end
  end


  def show
    @page_title = @group.name
    @partecipants = @group.partecipants
    @group_posts = @group.posts.published.paginate(:page => params[:page], :per_page => COMMENTS_PER_PAGE, :order => 'published_at DESC')

    respond_to do |format|
      format.html # show.html.erb
      format.xml { render :xml => @group }
    end
  end


  def new
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
      flash[:notice] = "Gli utenti potranno modificare le impostazioni avanzate."
    else
      flash[:notice] = "Gli utenti non potranno modificare le impostazioni avanzate."
    end

    respond_to do |format|
      format.js { render :update do |page|
        page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
      end
      }
    end

  rescue Exception => e
    respond_to do |format|
      flash[:error] = 'Errore nella modifica delle opzioni.'
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
      flash[:notice] = "Le proposte del gruppo saranno anonime di default"
    else
      flash[:notice] = "Le proposte del gruppo saranno palesi di default"
    end

    respond_to do |format|
      format.js { render :update do |page|
        page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
      end
      }
    end

  rescue Exception => e
    respond_to do |format|
      flash[:error] = 'Errore nella modifica delle opzioni.'
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
      flash[:notice] = "Le proposte del gruppo saranno visibili pubblicamente di default"
    else
      flash[:notice] = "Le proposte del gruppo non saranno visibili pubblicamente di default"
    end

    respond_to do |format|
      format.js { render :update do |page|
        page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
      end
      }
    end

  rescue Exception => e
    respond_to do |format|
      flash[:error] = 'Errore nella modifica delle opzioni.'
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
      flash[:notice] = "Le proposte avranno voto segreto di default"
    else
      flash[:notice] = "Le proposte avranno voto palese di default"
    end

    respond_to do |format|
      format.js { render :update do |page|
        page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
      end
      }
    end

  rescue Exception => e
    respond_to do |format|
      flash[:error] = 'Errore nella modifica delle opzioni.'
      format.js { render :update do |page|
        page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
      end
      }
    end
  end

  #crea un nuovo gruppo
  def create
    begin
      Group.transaction do

        params[:group][:default_role_actions].reject!(&:empty?)

        @group = Group.new(params[:group]) #crea il gruppo
        @group.current_user_id = current_user.id
        @group.save!
        Dir.mkdir "#{Rails.root}/private/elfinder/#{@group.id}"
      end
      respond_to do |format|
        flash[:notice] = 'Hai creato il gruppo.'
        format.html { redirect_to(@group) }
        #format.xml  { render :xml => @group, :status => :created, :location => @group }
      end #respond_to

    rescue ActiveRecord::ActiveRecordError => e
      respond_to do |format|
        flash[:error] = 'Errore nella creazione del gruppo.'
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
        partecipant_ids = @group.partecipant_ids
        partecipant_ids.each do |id|
          r = GroupPartecipationRequest.new({:group_id => @group.id, :user_id => id, :group_partecipation_request_status_id => 3})
          r.save
        end
      end

      respond_to do |format|
        if @group.save
          flash[:notice] = t('groups.confirm.update')
          format.html { redirect_to(@group) }
          # format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          #format.xml  { render :xml => @group.errors, :status => :unprocessable_entity }
        end
      end

    rescue ActiveRecord::ActiveRecordError => e
      puts e
      respond_to do |format|
        flash[:error] = t('groups.errors.update')
        format.html { render :action => "edit" }
      end
    rescue Exception => e
      puts e
      respond_to do |format|
        flash[:error] = t('groups.errors.update')
        format.html { render :action => "edit" }
      end
    end
  end


  def destroy
    @group.destroy

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
          flash[:notice] = 'Errore nella richiesta di partecipazione. Ma fai già parte di questo gruppo!'
        else
          flash[:error] = 'Fai già parte di questo gruppo ma la tua richiesta non è mai stata registrata. Dati corretti.'
        end
      else
        #inoltra la richiesta di partecipazione con stato IN ATTESA
        request = GroupPartecipationRequest.new
        request.user_id = current_user.id
        request.group_id = @group.id
        request.group_partecipation_request_status_id = 1 #in attesa...
        saved = request.save
        if (!saved)
          flash[:error] = 'Errore nella richiesta di partecipazione.'
        else
          flash[:notice] = 'Richiesta di partecipazione inviata correttamente.'
          notify_user_asked_for_partecipation(@group) #invia notifica ai portavoce
        end
      end
    else
      flash[:notice] = 'Hai già effettuato una richiesta di partecipazione a questo gruppo.'

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
        flash[:notice] = 'Ora segui questo gruppo.'
      end
    else
      flash[:error] = 'Stai già seguendo questo gruppo.'
    end
    redirect_to group_url(@group)
  end

  #fa seguire ad un utente più gruppi
  def ask_for_multiple_follow
    groups = params[:groups][:group_ids].split(';')

    number = 0
    groups.each do |group_id|
      follow = current_user.group_follows.find_or_create_by_group_id(group_id)
      if (follow.new_record?) #se non lo segue              
        number += 1
      end
    end
    flash[:notice] = "Ora segui #{number} nuovi gruppi"
    redirect_to home_path
  end


  #accetta una richiesta di partecipazione passandola allo stato IN VOTAZIONE se
  # è previsto o accettandola altrimenti.
  def partecipation_request_confirm
    authorize! :accept_requests, @group
    request = @group.partecipation_requests.pending.find_by_id(params[:request_id])
    if (!request)
      flash[:error] = 'Richiesta non trovata. Errore durante l' 'operazione'
      redirect_to group_url(@group)
    else
      if @group.request_by_portavoce?
        part = GroupPartecipation.new
        part.user_id = request.user_id
        part.group_id = @group.id
        part.partecipation_role_id = @group.partecipation_role_id
        part.save!
        request.group_partecipation_request_status_id = 3
      else
        request.group_partecipation_request_status_id = 2
      end
      saved = request.save
      if (!saved)
        flash[:error] = 'Errore durante l' 'operazione. Impossibile procedere.'
      else
        if @group.request_by_portavoce?
          flash[:notice] = 'La richiesta di partecipazione è passata in stato: ACCETTATA.'
        else
          flash[:notice] = 'La richiesta di partecipazione è passata in stato: IN VOTAZIONE.'
        end
        redirect_to group_url(@group)
      end
    end
  end

  def partecipation_request_decline
    authorize! :accept_requests, @group
    request = @group.partecipation_requests.pending.find_by_id(params[:request_id])
    if (!request)
      flash[:error] = 'Richiesta non trovata. Errore durante l' 'operazione'
      redirect_to group_url(@group)
    else
      if @group.request_by_portavoce?
        request.group_partecipation_request_status_id = 4
      else
        request.group_partecipation_request_status_id = 2
      end
      saved = request.save
      if (!saved)
        flash[:error] = 'Errore durante l' 'operazione. Impossibile procedere.'
      else
        if @group.request_by_portavoce?
          flash[:notice] = 'La richiesta di partecipazione è passata in stato: DECLINATA.'
        else
          flash[:notice] = 'La richiesta di partecipazione è passata in stato: IN VOTAZIONE.'
        end
        redirect_to group_url(@group)
      end
    end
  end


  def reload_storage_size

  end


  def partecipants_list_panel
    @partecipants = @group.group_partecipations.includes(:user)
  end


  def enable_areas
    @group.update_attribute(:enable_areas, true)
    redirect_to group_group_areas_path @group
  end

  def remove_post
    @publishing = @group.post_publishings.find_by_blog_post_id(params[:post_id])
    @publishing.destroy
    flash[:notice] = 'Il post è stato rimosso dalla bacheca del gruppo'

  rescue Exception => e
    respond_to do |format|
      flash[:error] = 'Errore nella rimozione del post dal gruppo'
      format.js { render :update do |page|
        page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
      end
      }
    end
  end

  protected

  def load_group
    @group = Group.find(params[:id])
  end

  def portavoce_required
    if !((current_user && (@group.portavoce.include? current_user)) || is_admin?)
      flash[:error] = t('error.portavoce_required')
      redirect_to group_url(@group)
    end
  end

  private

  def choose_layout
    'groups'
  end


end







