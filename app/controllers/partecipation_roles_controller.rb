#encoding: utf-8
class PartecipationRolesController < ApplicationController

  #l'utente deve aver fatto login
  before_filter :authenticate_user!

  before_filter :load_group, :except => [:destroy, :change_group_permission, :change_user_permission, :change_default_role, :edit, :update]
  before_filter :load_partecipation_role, :only => [:destroy, :edit, :update]
  before_filter :check_group_permissions, :only => [:change_group_permission]
  before_filter :check_role_permissions, :only => [:change_default_role]
  before_filter :check_user_permissions, :only => [:change_user_permission]

  def new
    @partecipation_role = @group.partecipation_roles.build
  end

  def create
    begin
      PartecipationRole.transaction do

        @partecipation_role = @group.partecipation_roles.new(params[:partecipation_role])
        @group.save!
      end

      respond_to do |format|
        flash[:notice] = t('info.participation_roles.role_created')
        format.js
        format.html { redirect_to edit_permissions_group_path(@group) }
      end

    rescue ActiveRecord::ActiveRecordError => e
      puts e
      respond_to do |format|
        flash[:error] = t('error.participation_roles.role_created')
        format.js { render 'partecipation_roles/errors/create' }
        format.html { redirect_to edit_permissions_group_path(@group) }
      end
    end
  end


  def edit
    authorize! :update, @partecipation_role
  end

  def update
    authorize! :update, @partecipation_role
    PartecipationRole.transaction do
      params[:partecipation_role][:group_id] = @partecipation_role.group_id
      @partecipation_role.attributes = params[:partecipation_role]
      @partecipation_role.save!
    end

    respond_to do |format|
      flash[:notice] = t('info.participation_roles.role_updated')
      format.js
    end
  rescue Exception => e
    respond_to do |format|
      flash[:error] = t('error.participation_roles.role_updated')
      format.js { render :update do |page|
        page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
      end }
    end
  end


  def destroy
    if @partecipation_role.destroy
      flash[:notice] = t('info.participation_roles.role_deleted')
    end
    respond_to do |format|
      format.js { render :update do |page|
        page.redirect_to edit_permissions_group_path(@partecipation_role.group)
      end
      }
    end
  end

  #modifica i permessi di un ruolo all'interno di un gruppo
  def change_group_permission
    ActionAbilitation.transaction do
      if (params[:block] == "true") #devo togliere i permessi
        abilitation = @role.action_abilitations.find_by_group_action_id_and_partecipation_role_id(params[:action_id], params[:role_id])
        if (abilitation)
          abilitation.destroy
          flash[:notice] = t('info.participation_roles.permissions_updated')
        end
      else #devo abilitare
        abilitation = @role.action_abilitations.find_or_create_by_group_action_id_and_partecipation_role_id_and_group_id(params[:action_id], params[:role_id], params[:group_id])
        flash[:notice] = t('info.participation_roles.permissions_updated')
      end
    end

    respond_to do |format|
      format.js { render :update do |page|
        page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
      end
      }
    end
  end

  #modifica il ruolo di un utente all'interno di un gruppo
  def change_user_permission
    gp = @group.group_partecipations.find_by_user_id(@user.id)
    gp.partecipation_role_id = @role.id
    gp.save!
    flash[:notice] = t('info.participation_roles.role_changed')
    respond_to do |format|
      format.js { render :update do |page|
        page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
      end
      }
    end
  end

  #modifica il ruolo predefinito per il gruppo
  #il ruolo predefinito è il ruolo assegnato ad ogni membro del gruppo all'atto dell'iscrizione
  #def change_default_role
  #  @group.partecipation_role_id=params[:role_id]
  #  @group.save!
  #  flash[:notice] ="Ruolo predefinito aggiornato."
  #  respond_to do |format|
  #    format.js { render :update do |page|
  #                   page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
  #                end
  #    }
  #  end
  #end


  protected

  #verifica che l'utente sia autenticato al sistema
  #e sia l'amministratore o portavoce del gruppo
  #e che il ruolo appartenga al gruppo indicato o sia member
  def check_role_permissions
    @group = Group.find(params[:group_id])
    @role = PartecipationRole.find(params[:role_id])
    if !((current_user && (@group.portavoce.include? current_user)) || is_admin?) || (@group != @role.group && @role.id != 1)
      flash[:error] = t('error.role_permission_change')
      respond_to do |format|
        format.js { render :update do |page|
          page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
        end
        }
      end
      false
    end
  end

  #verifica che l'utente sia autenticato al sistema
  #e sia l'amministratore o portavoce del gruppo
  #e che il ruolo appartenga al gruppo indicato
  def check_group_permissions
    @group = Group.find(params[:group_id])
    @role = PartecipationRole.find(params[:role_id])
    if !((current_user && (@group.portavoce.include? current_user)) || is_admin?) || (@group != @role.group)
      flash[:error] = t('error.role_permission_change')
      respond_to do |format|
        format.js { render :update do |page|
          page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
        end
        }
      end
      false
    end
  end


  #verifica che l'utente sia autenticato al sistema
  #e sia l'amministratore o portavoce del gruppo
  #e che il ruolo appartenga al gruppo indicato o sia generico,
  #e l'utente a cui si modifica il ruolo appartenga al gruppo
  #e non si stia cambiando il ruolo dell'unico amministratore
  def check_user_permissions
    @group = Group.find(params[:group_id])
    @role = PartecipationRole.find(params[:role_id])
    @user = User.find(params[:user_id])
    if !((current_user && (@group.portavoce.include? current_user)) || is_admin?) || #check user is administrator
        (@role.group && (@role.group != @group)) || #check role is a group role
        (!@group.partecipants.include? @user) || #check the user is really in the group
        ((@group.portavoce.include? @user) && (@group.portavoce.count == 1)) #check user is not the only administrator
      flash[:error] = t('error.role_permission_change')
      respond_to do |format|
        format.js { render :update do |page|
          page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
        end
        }
      end
      false
    end
  end

  def load_partecipation_role
    @partecipation_role = PartecipationRole.find(params[:id])
    @group = @partecipation_role.group
  end

  def load_group
    @group = Group.friendly.find(params[:group_id])
  end

end
