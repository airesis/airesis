#encoding: utf-8
class EventsController < ApplicationController
  
  layout "groups"
  
  before_filter :check_events_permissions, :only => [:new, :create]
  
  before_filter :load_group, :only => [:index]
  before_filter :load_event, :only => [:show, :destroy, :move, :resize, :edit]
  before_filter :check_event_edit_permission,:only => [:destroy, :move, :resize, :edit]
  
  def show
    respond_to do |format|
      format.js
      format.html
    end
  end
  
  
   def new 
    @group = Group.find_by_id(params[:group_id])
    @event = Event.new(:endtime => 1.hour.from_now, :period => "Non ripetere")
    @meeting = @event.build_meeting
    @election = @event.build_election
    @place = @meeting.build_place(:comune_id => "1330")
    if (params[:group_id])
      respond_to do |format|     
        format.js
        format.html { redirect_to :controller => 'groups', :action => 'edit_events', :id => params[:group_id], :new_event => 'true', :type => params[:type] }
      end
    end
  end
  
  def create
    #se è una votazione ignora tutto ciò che riguarda il luogo e le elezioni
    if (params[:event][:event_type_id] == "2")
      params[:event].delete(:meeting_attributes)
      params[:event].delete(:election_attributes)
    #se è un'elezione ignora tutto ciò che riguarda il luogo
    elsif (params[:event][:event_type_id] == "4")
      params[:event].delete(:meeting_attributes)
      params[:event][:election_attributes][:name] = params[:event][:title]
      params[:event][:election_attributes][:description] = params[:event][:description]
    #altrimenti elimina tutto ciò che riguarda l'elezione
    else
      params[:event].delete(:election_attributes)
    end
    
    Event.transaction do
      if (!params[:event][:period]) || (params[:event][:period] == "Non ripetere")
        @event = Event.new(params[:event])
        @event.save!
        if (params[:event][:event_type_id] == "4")
          @group.elections << @event.election
          @group.save           
        end
      else
        #      @event_series = EventSeries.new(:frequency => params[:event][:frequency], :period => params[:event][:repeats], :starttime => params[:event][:starttime], :endtime => params[:event][:endtime], :all_day => params[:event][:all_day])
        @event_series = EventSeries.new(params[:event])
        @event_series.save!
      end
    end
    
    rescue ActiveRecord::ActiveRecordError => e
      respond_to do |format|
        format.js {
          render :update do |page|             
            if @event
              page.alert @event.errors.full_messages.join(";")
            elsif @event_series
              page.alert @event_series.errors.full_messages.join(";")
            end
          end
        }
      end
  end
   
  def index
    @page_title = t('pages.events.index.title')
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
  
  def edit
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
  
  def load_group
    @group = Group.find_by_id(params[:group_id])
  end
  
  def load_event 
    @event = Event.find_by_id(params[:id])
    @group = @event.meeting_organizations.first.group rescue nil
  end
     
end
