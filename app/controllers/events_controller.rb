#encoding: utf-8
class EventsController < ApplicationController
  include NotificationHelper

  layout :choose_layout
  
  before_filter :check_events_permissions, :only => [:new, :create]
  
  before_filter :load_group, :only => [:index, :list]
  before_filter :load_event, :only => [:show, :destroy, :move, :resize, :edit]
  before_filter :check_event_edit_permission,:only => [:destroy, :move, :resize, :edit,:update]
  
  def show
    @page_title = @event.title
    respond_to do |format|
      format.js
      format.html
    end
  end
  
  
   def new 
    @event = Event.new(starttime: Time.now + 10.minutes, endtime: 1.day.from_now + 10.minutes, period: "Non ripetere")
    @meeting = @event.build_meeting
    @election = @event.build_election
    @place = @meeting.build_place(:comune_id => "1330")
    if params[:type] == 'election'
      @event.event_type_id = EventType::ELEZIONI
      @change_type = false
    elsif params[:type] == 'votation'
      @event.event_type_id = EventType::VOTAZIONE
      @change_type = false
    else
      @change_type = true
    end
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
    if params[:event][:event_type_id] == "2"
      params[:event].delete(:meeting_attributes)
      params[:event].delete(:election_attributes)
    #se è un'elezione ignora tutto ciò che riguarda il luogo
    elsif params[:event][:event_type_id] == EventType::ELEZIONI.to_s
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
        Resque.enqueue_at(@event.starttime, EventsWorker, {:action => EventsWorker::STARTVOTATION, :event_id => @event.id})
        Resque.enqueue_at(@event.endtime, EventsWorker, {:action => EventsWorker::ENDVOTATION, :event_id => @event.id})
      end

      notify_new_event(@event)
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
   
  def index    
    @page_title = @group ? t('pages.events.index.title') + " - " + @group.name : t('pages.events.index.title') 
    @can_edit_events = @group ? (can? :create_event, @group) : is_admin?
  end
  
  
  def list
    if @group
    @events = @group.events.all(:conditions => ["starttime >= '#{Time.at(params['start'].to_i).to_formatted_s(:db)}' and starttime < '#{Time.at(params['end'].to_i).to_formatted_s(:db)}'"] )
    else
    @events = Event.all(:conditions => ["starttime >= '#{Time.at(params['start'].to_i).to_formatted_s(:db)}' and starttime < '#{Time.at(params['end'].to_i).to_formatted_s(:db)}' and private = false"] )
    end
    events = [] 
    @events.each do |event|
      events << {:id => event.id, 
                 :title => event.title, 
                 :description => event.description || "Some cool description here...", 
                 :start => "#{event.starttime.iso8601}", 
                 :end => "#{event.endtime.iso8601}", 
                 :allDay => event.all_day, 
                 :recurring => event.event_series_id ? true: false,
                 :backgroundColor => event.backgroundColor,
                 :textColor => event.textColor,
                 :editable => !event.is_votazione?}
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
      @events = @event.event_series.events
      @event.update_events(@events, params[:event])
    elsif params[:event][:commit_button] == "Aggiorna tutte le occorrenze successive"
      @events = @event.event_series.events.all(:conditions => ["starttime > '#{@event.starttime.to_formatted_s(:db)}' "])
      @event.update_events(@events, params[:event])
    else
      @event.attributes = params[:event]
      @event.save
    end

    flash[:notice] = "Aggiornamento avvenuto correttamente"
    render :update do |page|
      page<<"$('#calendar').fullCalendar( 'refetchEvents' )"
      page<<"$('#desc_dialog').dialog('destroy')" 
      page.replace_html "flash_messages", :partial => 'layouts/flash', :locals => {:flash => flash}
    end
    
  end  
  
  def destroy
    if params[:delete_all] == 'true'
      @event.event_series.destroy
    elsif params[:delete_all] == 'future'
      @events = @event.event_series.events.all(:conditions => ["starttime > '#{@event.starttime.to_formatted_s(:db)}' "])
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

  def choose_layout
    @group ? "groups" : "open_space"
  end  


  def load_group
    @group = Group.find(params[:group_id]) rescue nil
  end
  
  def load_event 
    @event = Event.find_by_id(params[:id])
    @group = @event.meeting_organizations.first.group rescue nil
  end


  def check_event_edit_permission
    @event = Event.find_by_id(params[:id])
    if @event.is_votazione?
      if (params[:action] != 'destroy') || (@event.proposals.count > 0)
        permissions_denied
        return
      end
    end
    return true if is_admin?
    org = @event.organizers.first
    if !org
      permissions_denied
      return
    end
    p = org.scoped_partecipants(GroupAction::CREATE_EVENT)
    permissions_denied if (!current_user || !(p.include?current_user))
  end


  def check_events_permissions
    group_id = params[:group_id]
    @group = Group.find_by_id(group_id)
    return if is_admin?
    permissions_denied if !group_id
    permissions_denied if !@group
    permissions_denied if (cannot? :create_event, @group)
  end


end
