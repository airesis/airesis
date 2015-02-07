#encoding: utf-8
class QuorumsController < ApplicationController
  layout :choose_layout

  #security controls
  before_filter :authenticate_user!

  before_filter :load_group, except: :help

  authorize_resource :group

  load_and_authorize_resource class: 'BestQuorum', through: :group, shallow: true, parent: false, singleton: true, except: [:index]

  def index
    authorize! :index, BestQuorum
  end

  def new
    @page_title= t('pages.groups.edit_quorums.new_quorum.title')
    @quorum.attributes = {percentage: 0, good_score: 20, vote_percentage: 0, vote_good_score: 50}
    @group_participations_count = @group.scoped_participants(GroupAction::PROPOSAL_PARTICIPATION).count
    @vote_participants_count = @group.scoped_participants(GroupAction::PROPOSAL_VOTE).count
    respond_to do |format|
      format.js
      format.html
    end
  end

  def create
    @quorum.public = false
    if @quorum.save
      respond_to do |format|
        flash[:notice] = t('info.quorums.quorum_created')
        format.js
      end
    else
      respond_to do |format|
        flash[:error] = t('error.quorums.quorum_creation')
        format.js { render 'layouts/active_record_error', locals: {object: @quorum} }
      end
    end
  end

  def edit
    @page_title = t('pages.groups.edit_quorums.edit_quorum')
    @group_participations_count = @group.scoped_participants(GroupAction::PROPOSAL_PARTICIPATION).count
    @vote_participants_count = @group.scoped_participants(GroupAction::PROPOSAL_VOTE).count
  end


  def update
    if @quorum.update(best_quorum_params)
      respond_to do |format|
        flash[:notice] = t('info.quorums.quorum_updated')
        format.js
      end
    else
      respond_to do |format|
        flash[:error] = t('error.quorums.quorum_modification')
        format.js { render 'layouts/active_record_error', locals: {object: @quorum} }
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
      format.js { render 'layouts/success' }
    end
  end


  def help
    if params[:group_id]
      @group = Group.find(params[:group_id])
      @quorums = @group.quorums.active
    else
      @quorums = Quorum.visible.active.all
    end
    respond_to do |format|
      format.js
      format.html
    end
  end

  #retrieve a list of votation dates compatibles with that quorum
  def dates
    starttime = Time.now + @quorum.minutes.minutes + DEBATE_VOTE_DIFFERENCE
    if @group
      @dates = @group.events.not_visible.vote_period(starttime).collect { |p| ["da #{l p.starttime} a #{l p.endtime}", p.id, {'data-start' => (l p.starttime), 'data-end' => (l p.endtime), 'data-title' => p.title}] } #TODO:I18n
    else
      @dates = Event.visible.vote_period(starttime).collect { |p| ["da #{l p.starttime} a #{l p.endtime}", p.id] } #TODO:I18n
    end
  end

  protected

  def best_quorum_params
    quorum_params
  end

  def quorum_params
    params.require(:best_quorum).permit(:id, :name, :description, :percentage, :valutations, :days_m, :hours_m, :minutes_m, :minutes, :good_score, :vote_percentage, :vote_good_score)
  end

  def choose_layout
    @group ? 'groups' : 'open_space'
  end
end
