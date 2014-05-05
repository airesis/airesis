#encoding: utf-8
#todo che cazzo fa sto controller?
class RequestVotesController < ApplicationController
   
  before_filter :load_group, only: [:show,:edit,:update,:destroy,:ask_for_partecipation, :partecipation_request_confirm]
  before_filter :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  before_filter :check_author,   only: [:new, :create, :edit, :update, :destroy]
  before_filter :admin_required, only: [:new, :create, :destroy]
  
  
  
  #TODO
   def check_author
    #@group = Group.find(params[:id])
    #if ! current_user.is_my_blog? @group.id
    #  flash[:notice] = 'Non puoi modificare un gruppo che non ti appartiene.'
    #  redirect_to :back
    #end
   end
  
  def index
    @groups = Group.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  
  def show
    @partecipants = @group.partecipants
    @group_posts = @group.posts.published.order('published_at DESC').page(params[:page]).per(COMMENTS_PER_PAGE)

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  
  def new
    @group = Group.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
  end

  def create    
    @group = Group.new(params[:group])

    respond_to do |format|
      if @group.save
        flash[:notice] = 'Hai creato il gruppo.'
        format.html { redirect_to(@group) }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    
    begin
      Group.transaction do
      pop = @group.group_partecipations
      pop.each do |p|
        p.destroy
      end
      
      partecipant_ids = params[:group][:partecipant_tokens].split(",")
      partecipant_ids.each do |id|
        part = GroupPartecipation.new
        part.user_id = id
        part.group_id = @group.id        
        saved = part.save
        end
            
      end
  
      respond_to do |format|
        if @group.update_attributes(params[:group])
          flash[:notice] = 'Gruppo aggiornato correttamente.'
          format.html { redirect_to(@group) }
        else
          format.html { render action: "edit" }
        end
      end
    
    rescue ActiveRecord::ActiveRecordError => e
        respond_to do |format|
          flash[:notice] = 'Errore nell''aggiornamento del gruppo.'
          format.html { redirect_to edit_group_path(@group) }                  
        end         
    end
  end

  def destroy
    @group.destroy

    respond_to do |format|
      format.html { redirect_to(groups_url) }
    end
  end
  
  #fa partire una richiesta per la partecipazione dell'utente corrente al gruppo
  def ask_for_partecipation
          
   request = current_user.group_partecipation_requests.find_by_group_id(@group.id)
   if (!request)
     partecipation = current_user.groups.find_by_id(@group.id)
     if (partecipation)
       request = GroupPartecipationRequest.new
       request.user_id = current_user.id
       request.group_id = @group.id
       request.group_partecipation_request_status_id = 3
        saved = request.save
        if (!saved)
          flash[:notice] = 'Errore nella richiesta di partecipazione. Ma fai già parte di questo gruppo!'
        else
         flash[:error] = 'Fai già parte di questo gruppo ma la tua richiesta non è mai stata registrata. Dati corretti.'
        end       
     else     
       request = GroupPartecipationRequest.new
       request.user_id = current_user.id
       request.group_id = @group.id
       request.group_partecipation_request_status_id = 1
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
 
 #accetta una richiesta di partecipazione passandola allo stato IN VOTAZIONE
 def partecipation_request_confirm
   if ((current_user && (@group.portavoce.include?current_user)) || is_admin?)
     request = @group.partecipation_requests.pending.find_by_id(params[:request_id])
     if (!request)
       flash[:error] = 'Richiesta non trovata. Errore durante l''operazione'
       redirect_to group_url(@group)
     else
       request.group_partecipation_request_status_id = 2
       saved = request.save
       if (!saved)
         flash[:error] = 'Errore surante l''operazione. Impossibile procedere.'
       else
         flash[:notice] = 'La richiesta di partecipazione è passata in stato: IN VOTAZIONE.'
         redirect_to group_url(@group)
       end
     end
   else
     flash[:error] = 'Non hai i diritti per far procedere la richiesta di partecipazione. Solo il portavoce del gruppo o un amministratore di sistema possono procedere con l''operazione.'
     redirect_to group_url(@group)
   end
   
 end

end
