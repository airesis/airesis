#encoding: utf-8
class GroupInvitationsController < ApplicationController

  before_filter :authenticate_user!, only: [:new,:create]

  before_filter :authenticate_user_from_invite!, only: [:accept]

  before_filter :load_group, only: [:create]

  #controlla l'invito
  before_filter :check_invite, only: [:accept,:reject,:anymore]


  def new
    @group_invitation = GroupInvitation.new(group_id: params[:group_id])

    respond_to do |format|
      format.js
      format.html # new.html.erb
      #format.json { render json: @group_invitation }
    end
  end

  def create
    emails = params[:group_invitation][:emails_list]
    emails_list = emails.split ","

    GroupInvitation.transaction do
      emails_list.each do |email| #scorri tutti gli indirizzi email
        #controlla che non abbia bloccato la ricezione di inviti
        #che non sia già stato invitato precedentemente
        #che non faccia già parte del gruppo
        unless BannedEmail.find_by_email(email) || @group.invitation_emails.find_by_email(email) || @group.participants.find_by_email(email)
          @group_invitation_email = @group.invitation_emails.build(email: email)
          @group.save!
          @group_invitation = GroupInvitation.create(group_invitation_email_id: @group_invitation_email.id, inviter_id: current_user.id, testo: params[:group_invitation][:testo])
          ResqueMailer.delay.invite(@group_invitation.id)
          end
        end
    end

    respond_to do |format|
        flash[:notice] = "Inviti inviati correttamente!"
        format.js
        #format.html { redirect_to @group_invitation, notice: 'Group invitation was successfully created.' }
        #format.json { render json: @group_invitation, status: :created, location: @group_invitation }
    end
  end

  #link da email per accettare un invito
  def accept
    GroupInvitation.transaction do
      #consuma il token e salva l'id dell'utente che ha accettato l'invito
      @group_invitation.consumed = true
      @group_invitation.invited_id = current_user.id
      @group_invitation.save
      @group_invitation_email.accepted = 'Y'
      @group_invitation_email.save

      request = @group.participation_requests.build(user_id: current_user.id, group_participation_request_status_id: 3)
      request.save

      part = @group.group_participations.build(user_id: current_user.id, participation_role_id: @group.participation_role_id)
      part.save!

    end

    flash[:notice] = "Invito accettato! Ora fai parte di questo gruppo!"
    redirect_to @group
  end

  #link da email per rifiutare un invito
  def reject
    GroupInvitation.transaction do
      #consuma il token e salva l'id dell'utente che ha accettato l'invito
      @group_invitation.consumed = true
      #@group_invitation.invited_id = current_user.id
      @group_invitation.save
      @group_invitation_email.accepted = 'N'
      @group_invitation_email.save
    end

    flash[:notice] = "Invito rifiutato. Hai scelto di non partecipare a questo gruppo"
    redirect_to @group
  end

  #link da email per non ricevere più inviti
  #TODO deve essere possibile essere esclusi anche senza aver fatto login
  def anymore
    GroupInvitation.transaction do
      #consuma il token e salva l'id dell'utente che ha accettato l'invito
      @group_invitation.consumed = true
      #@group_invitation.invited_id = current_user.id
      @group_invitation.save
      @group_invitation_email.accepted = 'N'
      @group_invitation_email.save
      @banned = BannedEmail.new(email: params[:email]) #inserisci il record tra le mail da non contattare
      @banned.save
    end

    flash[:notice] = "Invito rifiutato. Hai scelto di non partecipare a questo gruppo e di non essere mai più invitato."
    redirect_to @group
  end

  protected

  def load_group
    @group = Group.find(params[:group_invitation][:group_id])
  end

  def check_invite
    @group = Group.find_by_id(params[:group_id])
    unless @group
      flash[:error] = "Gruppo non trovato"
      respond_to do |format|
        format.html error.html.erb
      end
      return false
    end
    @group_invitation_email = @group.invitation_emails.find_by_email(params[:email])
    unless @group
      flash[:error] = "Indirizzo email non trovato"
      respond_to do |format|
        format.html error.html.erb
      end
      return false
    end
    @group_invitation = @group_invitation_email.group_invitation
    unless @group_invitation.token == params[:token]
      flash[:error] = "Codice invito errato"
      respond_to do |format|
        format.html error.html.erb
      end
      return false
    end
    if @group_invitation.consumed
      flash[:error] = "Codice invito scaduto"
      respond_to do |format|
        format.html {render "error.html.erb"}
      end
      return false
    end
    if @group.participants.include? current_user
      flash[:error] = "Questo utente fa già parte del gruppo"
      respond_to do |format|
        format.html {render "error.html.erb"}
      end
      false
    end
  end


  def authenticate_user_from_invite!
    unless user_signed_in?
      session[:user_return_to] = request.url
      session[:user] = {}
      session[:user][:email] = params[:email]
      session[:invite] = {email: params[:email], token: params[:token], group_id: params[:group_id], return: request.url}
      if User.where(email: params[:email]).exists?
        redirect_to new_user_session_path(invite: params[:token], user: {login: params[:email]})
      else
        redirect_to new_user_registration_path(invite: params[:token])
      end

    end
  end

end
