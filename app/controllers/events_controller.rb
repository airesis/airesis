#encoding: utf-8
class EventsController < ApplicationController
  layout :choose_layout

  before_filter :load_group, only: [:index, :new, :create]

  load_and_authorize_resource :group
  load_and_authorize_resource :event, through: :group, shallow: true

  def index
    authorize! :view_data, @group if @group
    respond_to do |format|
      format.html do
        @page_title = @group ? t('pages.events.index.title') + " - " + @group.name : t('pages.events.index.title')
      end
      format.ics do
        calendar = Icalendar::Calendar.new
        @events.each do |event|
          calendar.add_event(event.to_ics)
        end
        calendar.publish
        render text: calendar.to_ical
      end
      format.json do
        @events = @events.time_scoped(Time.at(params['start'].to_i), Time.at(params['end'].to_i))
        events = []
        @events.each do |event|
          event_obj = event.to_fc
          if @group
            event_obj[:group] = @group.name
            event_obj[:group_url] = group_url(@group)
          elsif event.groups.first
            event_obj[:group] = event.groups.first.name
            event_obj[:group_url] = group_url(event.groups.first)
          end
          event_obj[:url] = @group ? group_event_url(@group, event) : event_url(event)
          events << event_obj
        end
        render text: events.to_json
      end
    end
  end

  def show
    authorize! :view_data, @group if @group
    @page_title = @event.title
    @event_comment = @event.event_comments.new
    @event_comments = @event.event_comments.includes(:user).order('created_at DESC').page(params[:page]).per(COMMENTS_PER_PAGE)
    respond_to do |format|
      format.html
      format.js
      format.ics do
        calendar = Icalendar::Calendar.new
        calendar.add_event(@event.to_ics)
        calendar.publish
        render text: calendar.to_ical
      end
    end
  end


  def new
    @title = @group ? "#{@group.name}" : ''
    if @group
      if params[:event_type_id] == EventType::VOTAZIONE.to_s
        authorize! :create_date, @group
      else
        authorize! :create_event, @group
      end
    else
      return unless admin_required
    end

    if params[:event_type_id] == EventType::VOTAZIONE.to_s
      @title += "- #{t('pages.events.new.title_event')}"
    else
      @title += "- #{t('pages.events.new.title_meeting')}"
    end

    @starttime = params[:starttime] ? Time.at(params[:starttime].to_i / 1000) : Time.now + 10.minutes
    @endtime = @starttime + 1.days

    @event = Event.new(starttime: @starttime, endtime: @endtime, period: "Non ripetere", event_type_id: params[:event_type_id])
    @meeting = @event.build_meeting
    @place = @meeting.build_place

    if params[:proposal_id]
      @event.proposal_id = params[:proposal_id]
    end
    if @group
      @event.private = true
      respond_to do |format|
        format.html { redirect_to controller: 'events', action: 'index', group_id: params[:group_id], new_event: 'true', event_type_id: (params[:event_type_id] || EventType::INCONTRO) }
        format.js
      end
    end
  end

  def create
    if @group
      if event_params[:event_type_id] == EventType::VOTAZIONE.to_s
        authorize! :create_date, @group
      else
        authorize! :create_event, @group
      end
    else
      return unless admin_required
    end

    Event.transaction do
      if (!event_params[:period]) || (event_params[:period] == "Non ripetere")
        @event.user = current_user
        @group ? @group.save! : @event.save!
        if @event.proposal_id.present?
          @proposal = Proposal.find(@event.proposal_id)
          @proposal.vote_period_id = @event.id
        end
      else
        @event_series = EventSeries.new(event_params)
        @event_series.save!
      end

    end

  rescue ActiveRecord::ActiveRecordError => e
    respond_to do |format|
      format.js { render 'layouts/active_record_error', locals: {object: (@event || @event_series)} }
    end
  end


  def move
    @event.move(params[:minute_delta].to_i, params[:day_delta].to_i, params[:all_day])
  end


  def resize
    @event.resize(params[:minute_delta].to_i, params[:day_delta].to_i)
  end

  def edit
  end

  def update
    if @event.update(event_params)
      flash[:notice] = t('info.events.event_updated')
      respond_to do |format|
        format.html { redirect_to @group ? group_event_url(@group, @event) : event_url(@event) }
        format.js
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.js { render 'layouts/active_record_error', locals: {object: @event || @event_series} }
      end
    end
  end

  def destroy
    if params[:delete_all] == 'true'
      @event.event_series.destroy
    elsif params[:delete_all] == 'future'
      @events = @event.event_series.events.where(["starttime > '#{@event.starttime.to_formatted_s(:db)}' "])
      @event.event_series.events.delete(@events)
    else
      @event.destroy
    end
    flash[:notice] = t('info.events.event_deleted')

    respond_to do |format|
      format.html {
        @group = @event.groups.first if @event.groups.count > 0
        redirect_to @group ? group_events_path(@group) : events_path
      }
    end
  end

  protected

  def event_params
    params[:event].delete(:meeting_attributes) if params[:event][:event_type_id] == EventType::VOTAZIONE.to_s
    params.require(:event).permit(:id, :title, :starttime, :endtime, :frequency, :all_day, :description, :event_type_id, :private, :proposal_id, meeting_attributes: [:id, place_attributes: [:id, :comune_id, :address, :latitude_original, :longitude_original, :latitude_center, :longitude_center, :zoom]])
  end

  def choose_layout
    @group ? "groups" : "open_space"
  end

  private

  def render_404(exception=nil)
    log_error(exception) if exception
    respond_to do |format|
      @title = t('error.error_404.events.title')
      @message = t('error.error_404.events.description')
      format.html { render "errors/404", status: 404, layout: true }
    end
    true
  end

end
