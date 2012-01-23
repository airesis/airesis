#encoding: utf-8
class GroupsController < ApplicationController
  layout "application", :except => [:edit, :edit_events]
  #layout "settings", :only => [:edit,:edit_events]
  #carica il gruppo
  before_filter :load_group, :except => [:index,:new,:create]
  
  ###SICUREZZA###
  
  #l'utente deve aver fatto login
  before_filter :authenticate_user!, :except => [:index,:show]
  
  
  #before_filter :check_author,   :only => [:new, :create, :edit, :update, :destroy]
  
  #l'utente deve essere amministratore
  before_filter :admin_required, :only => [:new, :create, :destroy]
  
   #l'utente deve essere portavoce o amministratore
  before_filter :portavoce_required, :only => [:partecipation_request_confirm, :edit, :update, :edit_events, :create_event]
  
  def index
    @groups = Group.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @groups }
    end
  end
  
  
  def show
    @partecipants = @group.partecipants
    @group_posts = @group.posts.published.paginate(:page => params[:page], :per_page => COMMENTS_PER_PAGE, :order => 'published_at DESC')
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @group }
    end
  end
  
  
  def new
    @group = Group.new(:accept_requests => 'p')
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @group }
    end
  end
  
  def edit
  end
  
  
  def get_events
    @events = @group.events
    events = [] 
    @events.each do |event|
      events << {:id => event.id, 
                 :title => event.title, 
                 :description => event.description || "Some cool description here...", 
                 :start => "#{event.starttime.iso8601}", 
                 :end => "#{event.endtime.iso8601}", 
                 :allDay => event.all_day, 
                 :recurring => (event.event_series_id)? true: false, 
                 :backgroundColor => event.backgroundColor,
                 :textColor => event.textColor}
    end
    render :text => events.to_json
  end
  
  
  def edit_events
    
  end
  
  def new_event 
    @event = Event.new(:endtime => 1.hour.from_now, :period => "Non ripetere", :organizer_id => @group.id)
    @meeting = @event.build_meeting
    @place = @meeting.build_place(:address => "Bologna")
  end
  
  def create    
    begin
      Group.transaction do
        @group = Group.new(params[:group])

        #@group.group_partecipations.build({:user_id => current_user.id})
        #@group.partecipation_requests.build({:user_id => current_user.id, :group_partecipation_request_status_id => 3})
        

        @group.partecipant_ids.each do |id|
            @group.partecipation_requests.build({:user_id => id, :group_partecipation_request_status_id => 3})
        end  
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

        #@group.partecipation_requests.each do |r|
        #  r.destroy
        #end
        partecipation = @group.group_partecipations.first(:conditions => {:partecipation_role_id => 2})
        if (partecipation)
          partecipation.partecipation_role_id = 1
          partecipation.save
        end
        partecipation = @group.group_partecipations.first(:conditions => {:user_id => params[:group][:porta_id]})
        if (partecipation)
          partecipation.partecipation_role_id = 2
          partecipation.save
        end
        
        @group.attributes = params[:group]
        partecipant_ids = @group.partecipant_ids
        partecipant_ids.each do |id|
          r = GroupPartecipationRequest.new({:group_id => @group.id,:user_id => id, :group_partecipation_request_status_id => 3}) 
          r.save
          
       #   border = params[:group][:interest_border_tkn]
      #  ftype = border[0,1] #tipologia (primo carattere)
      #  fid = border[2..-1]  #chiave primaria (dal terzo all'ultimo carattere)
      #  found = InterestBorder.table_element(border)
       
     #  if (found)  #se ho trovato qualcosa, allora l'identificativo è corretto e posso procedere alla creazione del confine di interesse
      #  interest_b = InterestBorder.find_or_create_by_ftype_and_foreign_id(ftype,fid)
      #  puts "New Record!" if (interest_b.new_record?)
      #  @group.interest_border_id = interest_b.id
        
     # end  
          
      end
      
#        
#        
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
      respond_to do |format|
        flash[:error] = t('groups.errors.update')
        format.html { render :action => "edit" }              
      end  
    rescue Exception => e       
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
     if !((current_user && (@group.portavoce = current_user)) || is_admin?)
      flash[:error] = 'Solo il portavoce del gruppo o un amministratore di sistema possono procedere con l''operazione.'
      redirect_to group_url(@group)
     end
  end
end
