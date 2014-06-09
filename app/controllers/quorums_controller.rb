#encoding: utf-8
class QuorumsController < ApplicationController
  include NotificationHelper

  layout :choose_layout

  #security controls
  before_filter :authenticate_user!

  before_filter :load_group, except: :help

  authorize_resource :group

  load_and_authorize_resource :best_quorum, parent: false, through: :group, singleton: true, except: [:index]

  def index
    authorize! :index, BestQuorum
  end

  def new
    @page_title= t('pages.groups.edit_quorums.new_quorum.title')
    @quorum = BestQuorum.new({percentage: 0, good_score: 20, vote_percentage: 0, vote_good_score: 50})
    @group_participations_count = @group.count_proposals_participants
    @vote_participants_count = @group.count_voter_participants
    respond_to do |format|
      format.js
      format.html
    end
  end

  def create
    @best_quorum.public = false
    if @best_quorum.save
      respond_to do |format|
        flash[:notice] = t('info.quorums.quorum_created')
        format.js
      end
    else
      respond_to do |format|
        flash[:error] = t('error.quorums.quorum_creation')
        format.js { render 'layouts/active_record_error', object: @best_quorum }
      end
    end
  end

  def edit
    @page_title = t('pages.groups.edit_quorums.edit_quorum')
    @group_participations_count = @group.count_proposals_participants
    @vote_participants_count = @group.count_voter_participants
  end


  def update
    @best_quorum.attributes = best_quorum_params
    if @best_quorum.save
      respond_to do |format|
        flash[:notice] = t('info.quorums.quorum_updated')
        format.js
      end
    else
      respond_to do |format|
        flash[:error] = t('error.quorums.quorum_modification')
        format.js { render 'layouts/active_record_error', locals: {object: @best_quorum} }
      end
    end
  end


  def destroy
    @quorum = @group.quorums.find_by_id(params[:id])
    @quorum.destroy
    flash[:notice] = t('info.quorums.quorum_deleted')

    respond_to do |format|
      format.js { render :update do |page|
        page.replace_html "flash_messages", partial: 'layouts/flash', locals: {flash: flash}
        page.replace_html "quorum_panel_container", partial: 'groups/quorums_panel'
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
          flash[:notice] =t('info.quorums.quorum_activated')
        else #lo disattivo
          quorum.active = false
          flash[:notice] =t('info.quorums.quorum_deactivated')
        end
        quorum.save!
      end
    end

    respond_to do |format|
      format.js { render :update do |page|
        page.replace_html "flash_messages", partial: 'layouts/flash', locals: {flash: flash}
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

  #retrieve a list of votation dates compatibles with that quorum
  def dates
    starttime = Time.now + @best_quorum.minutes.minutes + DEBATE_VOTE_DIFFERENCE
    if @group
      @dates = @group.events.private.vote_period(starttime).collect { |p| ["da #{l p.starttime} a #{l p.endtime}", p.id, {'data-start' => (l p.starttime), 'data-end' => (l p.endtime), 'data-title' => p.title}] } #TODO:I18n
    else
      @dates = Event.public.vote_period(starttime).collect { |p| ["da #{l p.starttime} a #{l p.endtime}", p.id] } #TODO:I18n
    end
  end

  protected

  def best_quorum_params
    params.require(:best_quorum).permit(:id, :name, :description, :percentage, :valutations, :minutes, :good_score)
  end

  def choose_layout
    @group ? "groups" : "open_space"
  end

end
