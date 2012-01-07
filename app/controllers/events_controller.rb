#encoding: utf-8
class EventsController < ApplicationController
  
  before_filter :admin_required, :only => [:new,:create,:move,:resize,:edit,:update,:destroy] 
  
  before_filter :load_event, :only => [:show, :destroy, :move, :resize, :edit]
  
  def show
    respond_to do |format|
      format.js
      format.html
    end
  end
  
  
  def new 
    @event = Event.new(:endtime => 1.hour.from_now, :period => "Non ripetere")
    @meeting = @event.build_meeting
    @place = @meeting.build_place(:address => "Bologna")
  end
  
  def edit
    @meeting = @event.meeting
    @place = @meeting.place if @meeting
  end
  
  def create
    if params[:event][:period] == "Non ripetere"
      @event = Event.new(params[:event])
    else
      #      @event_series = EventSeries.new(:frequency => params[:event][:frequency], :period => params[:event][:repeats], :starttime => params[:event][:starttime], :endtime => params[:event][:endtime], :all_day => params[:event][:all_day])
      @event_series = EventSeries.new(params[:event])
    end
  end
  
  def index
    
  end
  
  
  def get_events
    @events = Event.find(:all, :conditions => ["starttime >= '#{Time.at(params['start'].to_i).to_formatted_s(:db)}' and starttime < '#{Time.at(params['end'].to_i).to_formatted_s(:db)}'"] )
    events = [] 
    @events.each do |event|
      events << {:id => event.id, 
                 :title => event.title, 
                 :description => event.description || "Some cool description here...", 
                 :start => "#{event.starttime.iso8601}", 
                 :end => "#{event.endtime.iso8601}", 
                 :allDay => event.all_day, 
                 :recurring => (event.event_series_id)? true: false, 
                 :backgroundColor => event.backgroundColor,
                 :textColor => event.textColor}
    end
    render :text => events.to_json
  end
  
  
  
  def move
    if @event
      @event.starttime = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.starttime))
      @event.endtime = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.endtime))
      @event.all_day = params[:all_day]
      @event.save
    end
  end
  
  
  def resize
    if @event
      @event.endtime = (params[:minute_delta].to_i).minutes.from_now((params[:day_delta].to_i).days.from_now(@event.endtime))
      @event.save
    end    
  end
  
  
  
  def update
    @event = Event.find_by_id(params[:event][:id])
    if params[:event][:commit_button] == "Aggiorna tutte le occorrenze"
      @events = @event.event_series.events #.find(:all, :conditions => ["starttime > '#{@event.starttime.to_formatted_s(:db)}' "])
      @event.update_events(@events, params[:event])
    elsif params[:event][:commit_button] == "Aggiorna tutte le occorrenze successive"
      @events = @event.event_series.events.find(:all, :conditions => ["starttime > '#{@event.starttime.to_formatted_s(:db)}' "])
      @event.update_events(@events, params[:event])
    else
      @event.attributes = params[:event]
      @event.save
    end

    render :update do |page|
      page<<"$('#calendar').fullCalendar( 'refetchEvents' )"
      page<<"$('#desc_dialog').dialog('destroy')" 
    end
    
  end  
  
  def destroy
    if params[:delete_all] == 'true'
      @event.event_series.destroy
    elsif params[:delete_all] == 'future'
      @events = @event.event_series.events.find(:all, :conditions => ["starttime > '#{@event.starttime.to_formatted_s(:db)}' "])
      @event.event_series.events.delete(@events)
    else
      @event.destroy
    end
    
    render :update do |page|
      page<<"$('#calendar').fullCalendar( 'refetchEvents' )"
      page<<"$('#desc_dialog').dialog('destroy')" 
    end
    
  end
  
  
  
  protected
  
  def load_event 
    @event = Event.find_by_id(params[:id])
  end
end
