#encoding: utf-8
class EventsController < ApplicationController
  include NotificationHelper, GroupsHelper

  layout :choose_layout


  before_filter :load_group, :only => [:index, :list, :new, :create]
  before_filter :load_event, :only => [:show, :destroy, :move, :resize, :edit]

  def index
    authorize! :view_data, @group if @group
    @page_title = @group ? t('pages.events.index.title') + " - " + @group.name : t('pages.events.index.title')
    respond_to do |format|
      format.html
      format.ics do
        @events = @group ?
            @group.events.all :
            @events = Event.where(private: false).all
        calendar = Icalendar::Calendar.new
        @events.each do |event|
          calendar.add_event(event.to_ics)
        end
        calendar.publish
        render :text => calendar.to_ical
      end
    end
  end


  def show
    authorize! :view_data, @group if @group
    @page_title = @event.title
    @event_comment = @event.comments.new
    @event_comments = @event.comments.includes(:user).order('created_at DESC').page(params[:page]).per(COMMENTS_PER_PAGE)
    respond_to do |format|
      format.js
      format.html
      format.ics do
        calendar = Icalendar::Calendar.new
        calendar.add_event(@event.to_ics)
        calendar.publish
        render :text => calendar.to_ical
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
    @election = @event.build_election
    @place = @meeting.build_place(:comune_id => "1330")

    if params[:proposal_id]
      @event.proposal_id = params[:proposal_id]
    end
    if params[:group_id]
      @group = Group.find(params[:group_id])
      @event.private = true
      respond_to do |format|
        format.js
        format.html { redirect_to :controller => 'events', :action => 'index', :group_id => params[:group_id], :new_event => 'true', :type => params[:type] }
      end
    end
  end

  def create
    #se è una votazione ignora tutto ciò che riguarda il luogo e le elezioni
    if @group
      if params[:event][:event_type_id] == EventType::VOTAZIONE.to_s
        authorize! :create_date, @group
      else
        authorize! :create_event, @group
      end
    else
      return unless admin_required
    end

    if params[:event][:event_type_id] == EventType::VOTAZIONE.to_s
      params[:event].delete(:meeting_attributes)
    end

    Event.transaction do
      if (!params[:event][:period]) || (params[:event][:period] == "Non ripetere")
        @event = Event.new(params[:event])
        @event.user_id = current_user.id
        @event.save!


        @event.organizers << @group if @group

        if params[:event][:event_type_id] == EventType::ELEZIONI.to_s
          @group.elections << @event.election
          @group.save!
        end
      else
        #      @event_series = EventSeries.new(:frequency => params[:event][:frequency], :period => params[:event][:repeats], :starttime => params[:event][:starttime], :endtime => params[:event][:endtime], :all_day => params[:event][:all_day])
        @event_series = EventSeries.new(params[:event])
        @event_series.save!
      end

      #fai partire il timer per far scadere la proposta fuori dalla transazione
      if @event.is_votazione?
        EventsWorker.perform_at(@event.starttime, {:action => EventsWorker::STARTVOTATION, :event_id => @event.id})
        EventsWorker.perform_at(@event.endtime, {:action => EventsWorker::ENDVOTATION, :event_id => @event.id})
      end

      NotificationEventCreate.perform_async(current_user.id, @event.id)
    end

    if @event.proposal_id && !@event.proposal_id.empty?
      @proposal = Proposal.find(@event.proposal_id)
      @proposal.vote_period_id = @event.id
    end

  rescue ActiveRecord::ActiveRecordError => e
    respond_to do |format|
      format.js {
        render :update do |page|
          if @event
            page.alert @event.errors.full_messages.join("\n")
          elsif @event_series
            page.alert @event_series.errors.full_messages.join("\n")
          end
        end
      }
    end
  end

  def list
    conditions = "(starttime >= '#{Time.at(params['start'].to_i).to_formatted_s(:db)}' and starttime < '#{Time.at(params['end'].to_i).to_formatted_s(:db)}') or (endtime >= '#{Time.at(params['start'].to_i).to_formatted_s(:db)}' and endtime < '#{Time.at(params['end'].to_i).to_formatted_s(:db)}')"
    if @group
      @events = @group.events.where(conditions)
      @group_name = @group.name
      @group_url = group_url(@group)
    else
      @events = Event.where(conditions).includes(:organizers)
    end
    events = []
    @events.each do |event|
      event_obj = {:id => event.id,
                   :title => event.title,
                   :description => event.description || "Some cool description here...",
                   :start => "#{event.starttime.iso8601}",
                   :end => "#{event.endtime.iso8601}",
                   :allDay => event.all_day,
                   :recurring => event.event_series_id ? true : false,
                   :backgroundColor => event.backgroundColor,
                   :textColor => event.textColor,
                   :editable => !event.is_votazione?,
                   :url => event.is_elezione? ? election_path(event.election) : event_path(event)}
      if @group
        event_obj[:group] = @group_name
        event_obj[:group_url] = @group_url
      elsif event.organizers.first
        event_obj[:group] = event.organizers.first.name
        event_obj[:group_url] = group_url(event.organizers.first)
      end
      events << event_obj
    end
    render :text => events.to_json
  end


  def move
    authorize! :update, @event
    if @event
      @event.starttime = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.starttime))
      @event.endtime = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.endtime))
      @event.all_day = params[:all_day]
      @event.save
    end
  end


  def resize
    authorize! :update, @event
    if @event
      @event.endtime = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.endtime))
      @event.save
    end
  end

  def edit
    authorize! :update, @event
  end

  def update
    @event = Event.find_by_id(params[:event][:id])
    authorize! :update, @event
    if params[:event][:commit_button] == "Aggiorna tutte le occorrenze"
      @events = @event.event_series.events
      @event.update_events(@events, params[:event])
    elsif params[:event][:commit_button] == "Aggiorna tutte le occorrenze successive"
      @events = @event.event_series.events.all(:conditions => ["starttime > '#{@event.starttime.to_formatted_s(:db)}' "])
      @event.update_events(@events, params[:event])
    else
      @event.attributes = params[:event]
      @event.save!
    end

    flash[:notice] = t('info.events.event_updated')
    render :update do |page|
      page.reload
    end

  rescue ActiveRecord::ActiveRecordError => e
    respond_to do |format|
      format.js {
        render :update do |page|
          if @event
            page.alert @event.errors.full_messages.join("\n")
          elsif @event_series
            page.alert @event_series.errors.full_messages.join("\n")
          end
        end
      }
    end

  end

  def destroy
    authorize! :destroy, @event
    @group = @event.organizers.first if @event.organizers.count > 0
    if params[:delete_all] == 'true'
      @event.event_series.destroy
    elsif params[:delete_all] == 'future'
      @events = @event.event_series.events.all(:conditions => ["starttime > '#{@event.starttime.to_formatted_s(:db)}' "])
      @event.event_series.events.delete(@events)
    else
      @event.destroy
    end
    flash[:notice] = t('info.events.event_deleted')

    respond_to do |format|
      format.html {
        redirect_to @group ? group_events_path(@group) : events_path
      }
    end
  end

  protected

  def choose_layout
    @group ? "groups" : "open_space"
  end

  def load_event
    @event = Event.find(params[:id])
    @group = @event.organizers.first
  end

  private

  def render_404(exception=nil)
    log_error(exception) if exception
    respond_to do |format|
      @title = t('error.error_404.events.title')
      @message = t('error.error_404.events.description')
      format.html { render "errors/404", :status => 404, :layout => true }
    end
    true
  end

end
