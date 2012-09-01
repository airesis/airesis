#encoding: utf-8
class UsersController < ApplicationController
  
  before_filter :authenticate_user!, :except => [:index, :show, :confirm_credentials, :join_accounts]
  # Protect these actions behind an admin login
  # before_filter :admin_required, :only => [:suspend, :unsuspend, :destroy, :purge]
  before_filter :find_user, :only => [:show, :suspend, :unsuspend, :destroy, :purge, :update, :edit]
  
  def blank
    render :text => "Not Found", :status => 404
  end
  
  def confirm_credentials
    @user = User.new_with_session(nil,session)
    @orig = User.find_by_email(@user.email)
  end
  
  #unisce due account
  def join_accounts
    data = session["devise.facebook_data"] #prendi i dati di facebook dalla sessione
    if (params[:user][:email] && (data["extra"]["raw_info"]["email"] != params[:user][:email])) #se per caso viene passato un indirizzo email differente
      flash[:error] = 'Dai va là!'
      redirect_to confirm_credentials_users_url
    else
      auth = User.find_by_email_and_login(data["extra"]["raw_info"]["email"],params[:user][:login]) #trova l'utente del portale con username e password indicati
      if ( auth.valid_password?(params[:user][:password]) unless auth.nil?) #se la password fornita è corretta
        #imposta l'account come 'facebook'
        User.transaction do
          auth.account_type = 'facebook'
          auth.authentications.build(:provider => data['provider'], :uid => data['uid'], :token =>(data['credentials']['token'] rescue nil))
          auth.save
        end       
        #fine dell'unione
        flash[:info] = 'Account uniti correttamente!'
        sign_in_and_redirect auth, :event => :authentication
      else
        flash[:error] = 'Username, Email o password errati o inesistenti'
        redirect_to confirm_credentials_users_url        
      end
    end
  rescue Exception => e
    flash[:error] = 'Errore durante l''unione dei due account. L''operazione non è possibile al momento.'
    redirect_to confirm_credentials_users_url
  end
  
  def index
    @users = User.find(:all,:conditions => "upper(name) like upper('%#{params[:q]}%')")
    
    respond_to do |format|
      #format.xml  { render :xml => @users }
      format.json  { render :json => @users.to_json(:only => [:id, :name]) }
      format.html # index.html.erb
    end
  end
  
  def show        
    respond_to do |format|      
      flash.now[:notice] = "Fai clic sulle informazioni che desideri modificare." if (current_user == @user)
      format.html # show.html.erb
      #format.xml  { render :xml => @user }
    end
  end
  
  
  def alarm_preferences
    respond_to do |format|      
      flash.now[:notice] = "Fai clic sulle informazioni che desideri modificare." if (current_user == @user)
      format.html # show.html.erb
      #format.xml  { render :xml => @user }
    end
  end
  
  #aggiorni i confini di interesse dell'utente
  def set_interest_borders
    borders = params[:token][:interest_borders]
    #cancella i vecchi confini di interesse
    current_user.user_borders.each do |border|
      border.destroy
    end
    update_borders(borders)    
    flash[:notice] = "Confini di interesse aggiornati correttamente"
    AffinityHelper.calculate_group_affinity(current_user,Group.all)
    redirect_to :back
  end
  
  
  def update
    respond_to do |format|
      if (params[:image]) 
        image = Image.new({:image => params[:image]})
        image.save!
        @user.image_id = image.id
      end
      
      if @user.update_attributes(params[:user])                     
        flash[:notice] = t(:user_updated)
        format.js do
          render :update do |page|
            page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
            page.replace_html "user_profile_container", :partial => "user_profile"          
          end
        end
        format.html { 
          if params[:back] == "home"
            redirect_to home_url
          else
            redirect_to @user 
          end  
        }
        format.xml  { render :xml => @proposal }      
      else
        @user.errors.full_messages.each do |msg|
          flash[:error] = msg
        end
        format.js do
          render :update do |page|            
            page.replace_html "error_updating", :partial => 'layouts/flash', :locals => {:flash => flash}
          end
        end
        format.html { 
          if params[:back] == "home"
            redirect_to home_url
          else
           render :action => "show"
          end 
        }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # There's no page here to update or destroy a user.  If you add those, be
  # smart -- make sure you check that the visitor is authorized to do so, that they
  # supply their old password along with a new one to update it, etc.
  
  protected
  def find_user
    @user = User.find(params[:id])
  end
  
  
  
  
   def update_borders(borders)
     #confini di interesse, scorrili
    borders.split(',').each do |border| #l'identificativo è nella forma 'X-id'
      ftype = border[0,1] #tipologia (primo carattere)
      fid = border[2..-1] #chiave primaria (dal terzo all'ultimo carattere)
      found = InterestBorder.table_element(border)
      
      if (found)  #se ho trovato qualcosa, allora l'identificativo è corretto e posso procedere alla creazione del confine di interesse
        interest_b = InterestBorder.find_or_create_by_territory_type_and_territory_id(InterestBorder::I_TYPE_MAP[ftype],fid)
        puts "New Record!" if (interest_b.new_record?)
        i = current_user.user_borders.build({:interest_border_id => interest_b.id})
        i.save
      end
    end
  end
end
