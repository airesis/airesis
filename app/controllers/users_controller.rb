# controller for users
class UsersController < ApplicationController
  include UsersHelper
  layout :choose_layout

  before_filter :authenticate_user!, except: [:index, :show, :confirm_credentials, :join_accounts]

  before_filter :load_user, only: [:show, :update, :show_message, :send_message]

  def confirm_credentials
    @user = User.new_with_session(nil, session)
    @orig = User.find_by_email(@user.email)
  end

  # joins two different account when logging in
  def join_accounts
    oauth_data = session['devise.omniauth_data']
    oauth_data_parser = OauthDataParser.new(oauth_data)
    raw_info = oauth_data_parser.raw_info
    user_info = oauth_data_parser.user_info

    if wrong_join_accounts_params?(user_info[:email])
      flash[:error] = t('error.users.join_accounts')
      return redirect_to confirm_credentials_users_url
    end

    user = User.find_by(email: user_info[:email]) #trova l'utente del portale con email e password indicati
    unless user
      flash[:error] = t('error.users.join_accounts')
      return redirect_to confirm_credentials_users_url
    end

    if user.valid_password?(params[:user][:password]) #se la password fornita è corretta
      user.oauth_join(oauth_data)
      flash[:notice] = t('info.user.account_joined')
      sign_in_and_redirect user, event: :authentication
    else
      flash[:error] = t('error.users.join_accounts_password')
      redirect_to confirm_credentials_users_url
    end
  end

  def index
    return redirect_to root_path if user_signed_in?
    @users = User.where('upper(name) like upper(?)', "%#{params[:q]}%")

    respond_to do |format|
      format.html
      format.json { render json: @users.to_json(only: [:id, :name]) }
    end
  end

  def show
    respond_to do |format|
      flash.now[:info] = t('info.user.click_to_change') if (current_user == @user)
      format.html # show.html.erb
    end
  end


  def alarm_preferences
    @user = current_user
    respond_to do |format|
      flash.now[:info] = t('info.user.click_to_change') if (current_user == @user)
      format.html # show.html.erb
    end
  end

  def border_preferences
    @user = current_user
  end

  def privacy_preferences
    @user = current_user
  end

  def statistics
    @user = current_user
    @integrated_count = @user.proposal_comments.contributes.integrated.count
    @spam_count = @user.proposal_comments.contributes.spam.count
    @noisy_count = @user.proposal_comments.contributes.noisy.count
    @contributes_count = @user.proposal_comments.contributes.count
    @comments_count = @user.proposal_comments.comments.count
    @proposals_count = @user.proposals.count
  end

  def change_show_tooltips
    current_user.show_tooltips = params[:active]
    current_user.save!
    params[:active] == 'true' ?
      flash[:notice] = t('info.user.tooltips_enabled') :
      flash[:notice] = t('info.user.tooltips_disabled')

    respond_to do |format|
      format.js { render partial: 'layouts/messages' }
    end

  rescue Exception => e
    respond_to do |format|
      flash[:error] = t('error.setting_preferences')
      format.js { render 'layouts/error' }
    end
  end

  def change_show_urls
    current_user.show_urls = params[:active]
    current_user.save!
    params[:active] == 'true' ?
      flash[:notice] = t('info.user.url_shown') :
      flash[:notice] = t('info.user.url_hidden')

    respond_to do |format|
      format.js { render partial: 'layouts/messages' }
    end

  rescue Exception => e
    respond_to do |format|
      flash[:error] = t('error.setting_preferences')
      format.js { render partial: 'layouts/messages' }
    end
  end

  def change_receive_messages
    current_user.receive_messages = params[:active]
    current_user.save!
    if params[:active] == 'true'
      flash[:notice] = t('info.private_messages_active')
    else
      flash[:notice] = t('info.private_messages_inactive')
    end

    respond_to do |format|
      format.js { render partial: 'layouts/messages' }
    end

  rescue Exception => e
    respond_to do |format|
      flash[:error] = t('error.setting_preferences')
      format.js { render 'layouts/error' }
    end
  end

  #change default user locale
  def change_locale
    current_user.locale = SysLocale.find(params[:locale])
    current_user.save!

    flash[:notice] = t('info.locale_changed')


    respond_to do |format|
      format.js { render partial: 'layouts/messages' }
    end

  rescue Exception => e
    respond_to do |format|
      flash[:error] = t('error.setting_preferences')
      format.js { render 'layouts/error' }
    end
  end

  def change_time_zone
    current_user.time_zone = params[:time_zone]
    current_user.save!

    flash[:notice] = t('info.user.time_zone_changed')


    respond_to do |format|
      format.js { render partial: 'layouts/messages' }
    end

  rescue Exception => e
    respond_to do |format|
      flash[:error] = t('error.setting_preferences')
      format.js { render 'layouts/error' }
    end
  end

  #enable or disable rotp feature
  def change_rotp_enabled
    authorize! :change_rotp_enabled, current_user
    current_user.rotp_enabled = params[:active]
    if params[:active] == 'true'
      current_user.rotp_secret = ROTP::Base32.random_base32
      flash[:notice] = t('info.rotp_active')
    else
      flash[:notice] = t('info.rotp_inactive')
    end
    current_user.save!

    respond_to do |format|
      format.js
    end

  rescue Exception => e
    respond_to do |format|
      flash[:error] = t('error.setting_preferences')
      format.js { render 'layouts/error' }
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
    flash[:notice] = t('info.user.update_border')
    redirect_to :back
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        flash[:notice] = t('info.user.info_updated')
        flash[:notice] += t('info.user.confirm_email') if params[:user][:email] && @user.email != params[:user][:email]
        format.js
        format.html {
          if params[:back] == 'home'
            redirect_to home_url
          else
            redirect_to @user
          end
        }
      else
        @user.errors.full_messages.each do |msg|
          flash[:error] = msg
        end
        format.html {
          if params[:back] == 'home'
            redirect_to home_url
          else
            render action: 'show'
          end
        }
        format.js { render 'layouts/error' }
      end
    end
  end

  #mostra la form di invio messaggio all'utente
  def show_message
    authorize! :send_message, @user
  end

  #invia un messaggio all'utente
  def send_message
    authorize! :send_message, @user
    ResqueMailer.user_message(params[:message][:subject], params[:message][:body], current_user.id, @user.id).deliver_later
    flash[:notice] = t('info.message_sent')
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def autocomplete
    @group = Group.friendly.find(params[:group_id])
    users = @group.participants.autocomplete(params[:term])
    users = users.map do |u|
      {id: u.id, identifier: "#{u.surname} #{u.name}", image_path: "#{avatar(u, size: 20)}"}
    end
    render json: users
  end

  protected

  def wrong_join_accounts_params?(user_email)
    [params[:user][:email], params[:user][:password]].any? &:blank? || user_email != params[:user][:email]
  end

  def user_params
    params.require(:user).permit(:login, :name, :email, :surname, :password, :password_confirmation, :sex, :remember_me, :accept_conditions, :receive_newsletter, :sys_locale_id, :time_zone, :avatar)
  end

  def choose_layout
    if ['index'].include? action_name
      'open_space'
    elsif ['confirm_credentials'].include? action_name
      'application'
    else
      'users'
    end
  end

  def load_user
    @user = User.find(params[:id])
  end

  def update_borders(borders)
    #confini di interesse, scorrili
    borders.split(',').each do |border| #l'identificativo è nella forma 'X-id'
      ftype = border[0, 1] #tipologia (primo carattere)
      fid = border[2..-1] #chiave primaria (dal terzo all'ultimo carattere)
      found = InterestBorder.table_element(border)

      if found #if I found something so the ID is correct and I can proceed with geographic border creation
        interest_b = InterestBorder.find_or_create_by(territory_type: InterestBorder::I_TYPE_MAP[ftype], territory_id: fid)
        i = current_user.user_borders.build({interest_border_id: interest_b.id})
        i.save
      end
    end
  end
end
