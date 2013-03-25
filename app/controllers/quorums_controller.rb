#encoding: utf-8
class QuorumsController < ApplicationController
  include NotificationHelper

  #load group
  before_filter :load_group, :except => :help
  before_filter :load_quorum, :only => [:edit, :update, :destroy]

  #security controls
  before_filter :authenticate_user!

  before_filter :check_permissions, :only => [:new,:create,:edit,:update,:destroy,:change_status]


  def new
    @quorum = Quorum.new
    @partecipants_count = @group.count_voter_partecipants #_partecipants.count
    respond_to do |format|
      format.js
    end
  end

  def create
    begin
      Quorum.transaction do
        @quorum = @group.quorums.build(params[:quorum])
        @quorum.public = false
        @group.save!
      end

      respond_to do |format|
        flash[:notice] = 'Quorum creato correttamente'
        format.js { render :update do |page|
          page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
          page.replace_html "quorum_panel_container", :partial => 'groups/quorums_panel'
          page.call "hideNewQuorumPanel"
          page.call "generateTable"
        end
        }
      end

    rescue Exception => e
      respond_to do |format|
        flash[:error] = 'Errore nella creazione del quorum.'
        format.js { render :update do |page|
          page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
          page.alert @quorum.errors.full_messages.join(";") if (@quorum && @quorum.errors)
        end
        }
        #format.html { redirect_to edit_permissions_group_path(@quorum) }
      end
    end
  end

  def edit
    @partecipants_count = @group.count_voter_partecipants
  end


  def update
    Quorum.transaction do
      @quorum.attributes = params[:quorum]
      @quorum.save!
    end

    respond_to do |format|
      flash[:notice] = 'Quorum aggiornato correttamente'
      format.js { render :update do |page|
        page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
        page.replace_html "quorum_panel_container", :partial => 'groups/quorums_panel'
        page.call "hideEditQuorumPanel"
        page.call "generateTable"
      end
      }
    end

  rescue Exception => e
    respond_to do |format|
      flash[:error] = "Errore nell'aggiornanto del quorum."
      format.js { render :update do |page|
        page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
        page.alert @quorum.errors.full_messages.join(";") if (@quorum && @quorum.errors)
      end
      }
    end
  end


  def destroy
    @quorum = @group.quorums.find_by_id(params[:id])
    @quorum.destroy
    flash[:notice] = 'Quorum eliminato correttamente'

    respond_to do |format|
      format.js { render :update do |page|
        page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
        page.replace_html "quorum_panel_container", :partial => 'groups/quorums_panel'
      end
      }
    end
  end

  def change_status
    Quorum.transaction do
      quorum = @group.quorums.find_by_id(params[:id])
      if quorum
        if params[:active] == "true" #devo togliere i permessi
          quorum.active = true
          flash[:notice] ="Quorum attivato."
        else #lo disattivo
          quorum.active = false
          flash[:notice] ="Quorum disattivato."
        end
        quorum.save!
      end
    end

    respond_to do |format|
      format.js { render :update do |page|
        page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
      end
      }
    end
  end


  def help
    if params[:group_id]
      @group = Group.find(params[:group_id])
      @quorums = @group.quorums.active
    else
      @quorums = Quorum.public.active.all
    end
    respond_to do |format|
      format.js
      format.html
    end
  end


  private
  def check_permissions
    return  if @group.portavoce.include? current_user
    flash[:error] = t(:permissions_required)
    respond_to do |format|
      format.js { render :update do |page|
        page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
      end }
    end
  end

  protected

  def load_group
    @group = Group.find(params[:group_id])
  end

  def load_quorum
    @quorum = Quorum.find(params[:id])
  end

end
