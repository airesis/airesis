#encoding: utf-8
class GroupsController < ApplicationController
  include NotificationHelper
  
  layout :choose_layout
  #carica il gruppo
  before_filter :load_group, :except => [:index,:new,:create,:ask_for_multiple_follow]
  
  ###SICUREZZA###
  
  #l'utente deve aver fatto login
  before_filter :authenticate_user!, :except => [:index,:show]
  
  
  #before_filter :check_author,   :only => [:new, :create, :edit, :update, :destroy]
  
  #l'utente deve essere amministratore
  before_filter :admin_required, :only => [:destroy]
  
   #l'utente deve essere portavoce o amministratore
  before_filter :portavoce_required, :only => [:partecipation_request_confirm, :edit, :update, :edit_permissions]
  
  def index
    @page_title = t("pages.groups.index.title")
    @groups = Group.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @groups }
    end
  end
  
  
  def show
    @page_title = @group.name
    @partecipants = @group.partecipants
    @group_posts = @group.posts.published.paginate(:page => params[:page], :per_page => COMMENTS_PER_PAGE, :order => 'published_at DESC')
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @group }
    end
  end
  
  
  def new
    @page_title = t("pages.groups.new.title")
    @group = Group.new(:accept_requests => 'p')
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @group }
    end
  end
  
  def edit
    @page_title = t("pages.groups.edit.title")
  end
  
    
  def edit_events
    @page_title = t("pages.groups.edit_events.title")
  end
  
  def edit_permissions
    @page_title = t("pages.groups.edit_permissions.title")    
  end
  
  def new_event
    @event = Event.new(:period => "Non ripetere", :organizer_id => @group.id)
    if (params[:date])
      @event.starttime = Date.parse(params[:date]) + 1.hour
    else
      @event.starttime = Date.today + 1.hour
    end
    
    @event.event_type_id = 4 if (params[:type] == 'election')
    @event.endtime = @event.starttime + 7.day
    @meeting = @event.build_meeting
    @place = @meeting.build_place
    @election = @event.build_election
    @election.groups_end_time = @event.starttime + 2.day
    @election.candidates_end_time = @event.starttime + 4.day
  end
  
  #crea un nuovo gruppo
  def create    
    begin
      Group.transaction do
        
        #l'utente che crea il gruppo è automaticamente partecipante e portavoce
        params[:group][:partecipant_ids] -= current_user.id rescue
                        
        @group = Group.new(params[:group]) #crea il gruppo
  
        #se ci sono già dei partecipanti al gruppo, inserisci a sistema una richiesta di partecipazione accettata per ognuno        
        @group.partecipant_ids.each do |id|            
            @group.partecipation_requests.build({:user_id => id, :group_partecipation_request_status_id => 3}) if (id != current_user.id)
        end
                 
        #fai si che chi crea il gruppo ne sia anche portavoce
        @group.partecipation_requests.build({:user_id => current_user.id, :group_partecipation_request_status_id => 3})
         
        @group.group_partecipations.build({:user_id => current_user.id, :partecipation_role_id => 2}) #portavoce
                
        @group.save!
                
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
  end #create
  
  def update
    
    begin
      Group.transaction do
       
        @group.attributes = params[:group]
        partecipant_ids = @group.partecipant_ids
        partecipant_ids.each do |id|
          r = GroupPartecipationRequest.new({:group_id => @group.id,:user_id => id, :group_partecipation_request_status_id => 3}) 
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
      if (partecipation)  #verifica se per caso non fa già parte del gruppo
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
      request = @group.partecipation_requests.pending.find_by_id(params[:request_id])
      if (!request)
        flash[:error] = 'Richiesta non trovata. Errore durante l''operazione'
        redirect_to group_url(@group)
      else
        if @group.request_by_portavoce?
          part = GroupPartecipation.new
          part.user_id = request.user_id
          part.group_id = @group.id        
          part.save!
          request.group_partecipation_request_status_id = 3
        else
          request.group_partecipation_request_status_id = 2
        end    
        saved = request.save
        if (!saved)
          flash[:error] = 'Errore durante l''operazione. Impossibile procedere.'
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
  
  
  
  protected
  
  def load_group
    @group = Group.find(params[:id])
  end
  
  def portavoce_required
     if !((current_user && (@group.portavoce.include?current_user)) || is_admin?)
      flash[:error] = t('error.portavoce_required')
      redirect_to group_url(@group)
     end
  end
  
  private

  def choose_layout    
    if [ 'new','index'].include? action_name
      'settings'
    else
      'groups'
    end
  end
  
  
end
