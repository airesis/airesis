#encoding: utf-8
class UsersController < ApplicationController
  
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
    if (params[:user][:email] && (data["user_info"]["email"] != params[:user][:email])) #se per caso viene passato un indirizzo email differente
      flash[:error] = 'Dai va là!'
      redirect_to confirm_credentials_users_url
    else
      auth = User.find_by_email_and_login(data["user_info"]["email"],params[:user][:login]) #trova l'utente del portale con username e password indicati
      if ( auth.valid_password?(params[:user][:password]) unless auth.nil?) #se la password fornita è corretta
        #imposta l'account come 'facebook'
        User.transaction do
          auth.account_type = 'facebook'
          auth.authentications.build(:provider => data['provider'], :uid => data['uid'], :token =>(data['credentials']['token'] rescue nil))
          auth.save
        end       
        #fine dell'unione
        flash[:info] = 'Unione!'
        sign_in_and_redirect auth, :event => :authentication
      else
        flash[:error] = 'Username, Email o password errati o inesistenti'
        redirect_to confirm_credentials_users_url        
      end
    end
  rescue ActiveRecord::ActiveRecordError => e
    flash[:error] = 'Errore durante l''unione dei due account. L''operazione non è possibile al momento.'
    redirect_to users_sign_in_url
  end
  
  def index
    @users = User.find(:all,:conditions => "upper(name) like upper('%#{params[:q]}%')")
    
    respond_to do |format|
      format.xml  { render :xml => @users }
      format.json  { render :json => @users.to_json(:only => [:id, :name]) }
      format.html # index.html.erb
    end
  end
  
  def show        
    respond_to do |format|      
      flash.now[:notice] = "Fai clic sulle informazioni che desideri modificare." if (current_user == @user)
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end
  
  # render new.rhtml
  def new
    @user = User.new
  end
  
  def create
    logout_keeping_session!
    puts params[:user][:name]
    @user = User.new(params[:user])
    
    @user.register! if @user && @user.valid?
    success = @user && @user.valid?
    
    if success && @user.errors.empty?
      #   redirect_back_or_default('/')
      flash[:notice] = "Grazie per esserti registrato! Riceverai a breve una mail con il codice per attivare il tuo account."
    else
      flash.now[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
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
        format.html { redirect_to  @user }
        format.xml  { render :xml => @proposal }      
      else
        @user.errors.each do |attr,msg|
          flash[:error] = msg
        end
        format.js do
          render :update do |page|            
            page.replace_html "error_updating", :partial => 'layouts/flash', :locals => {:flash => flash}
          end
        end
        format.html { render :action => "show" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  
  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
      when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to '/login'
      when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default('/')
    else 
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default('/')
    end
  end
  
  def suspend
    @user.suspend! 
    redirect_to users_path
  end
  
  def unsuspend
    @user.unsuspend! 
    redirect_to users_path
  end
  
  def destroy
    @user.delete!
    redirect_to users_path
  end
  
  def purge
    @user.destroy
    redirect_to users_path
  end
  
  # There's no page here to update or destroy a user.  If you add those, be
  # smart -- make sure you check that the visitor is authorized to do so, that they
  # supply their old password along with a new one to update it, etc.
  
  protected
  def find_user
    @user = User.find(params[:id])
  end
  
end
