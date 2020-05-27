class EventsController < ApplicationController
  layout :choose_layout

  before_action :load_group, only: %i[index new create]

  load_and_authorize_resource :group
  load_and_authorize_resource :event, through: :group, shallow: true

  def index
    authorize! :view_data, @group if @group
    respond_to do |format|
      format.html do
        @page_title = @group ? "#{t('pages.events.index.title')} - #{@group.name}" : t('pages.events.index.title')
      end
      format.ics do
        respond_with_ical_index
      end
      format.json do
        respond_with_json_index
      end
    end
  end

  def show
    authorize! :view_data, @group if @group
    @page_title = @event.title
    @event_comment = @event.event_comments.new
    @event_comments = @event.event_comments.includes(:user).order('created_at DESC').page(params[:page]).per(COMMENTS_PER_PAGE)
    respond_to do |format|
      format.html do
        @proposals = @event.proposals.for_list(current_user.try(:id)) if @event.votation?
      end
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
    event_type = params[:event_type_id] || EventType::MEETING

    if @group
      if event_type == EventType::VOTATION.to_s
        authorize! :create_date, @group
      else
        authorize! :create_event, @group
      end
    else
      if params[:proposal_id].present?
        proposal = Proposal.find(params[:proposal_id])
        return unless can?(:set_votation_date, proposal)
      else
        return unless admin_required
      end
    end

    @page_title = @group ? @group.name.to_s : ''
    @page_title += if event_type == EventType::VOTATION.to_s
                     "- #{t('pages.events.new.title_event')}"
                   else
                     "- #{t('pages.events.new.title_meeting')}"
                   end

    @starttime = calculate_starttime
    @endtime = @starttime + 1.day

    @event = Event.new(starttime: @starttime, endtime: @endtime, period: 'Non ripetere',
                       event_type_id: event_type)
    @meeting = @event.build_meeting
    @place = @meeting.build_place

    @event.proposal_id = params[:proposal_id] if params[:proposal_id]
    @event.private = @group.present?
  end

  def create
    if @group
      if event_params[:event_type_id] == EventType::VOTATION.to_s
        authorize! :create_date, @group
      else
        authorize! :create_event, @group
      end
    else
      if @event.proposal_id.present?
        proposal = Proposal.find(@event.proposal_id)
        return unless can?(:set_votation_date, proposal)
      else
        return unless admin_required
      end
    end

    Event.transaction do
      @event.user = current_user
      @group ? @group.save! : @event.save!
      if @event.proposal_id.present?
        @proposal = Proposal.find(@event.proposal_id)
        @proposal.vote_period_id = @event.id
      end
    end

    respond_to do |format|
      format.html { redirect_to @group ? group_events_url(@group) : events_url }
      format.js
    end
  rescue ActiveRecord::ActiveRecordError => e
    respond_to do |format|
      format.js { render 'layouts/active_record_error', locals: { object: @event } }
    end
  end

  def move
    @event.move(params[:minute_delta].to_i, params[:day_delta].to_i, params[:all_day])
    render nothing: true
  end

  def resize
    @event.resize(params[:minute_delta].to_i, params[:day_delta].to_i)
    render nothing: true
  end

  def edit; end

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
        format.js { render 'layouts/active_record_error', locals: { object: @event } }
      end
    end
  end

  def destroy
    @event.destroy
    flash[:notice] = t('info.events.event_deleted')

    respond_to do |format|
      format.html do
        @group = @event.groups.first if @event.groups.count > 0
        redirect_to @group ? group_events_path(@group) : events_path
      end
    end
  end

  protected

  def calculate_starttime
    return 10.minutes.from_now unless params[:starttime]

    ret = Time.zone.at(params[:starttime].to_i / 1000)
    ret = ret.change(hour: Time.zone.now.hour, min: Time.zone.now.min) unless params[:has_time] == 'true'
    ret
  end

  def event_params
    params[:event].delete(:meeting_attributes) if params[:event][:event_type_id] == EventType::VOTATION.to_s
    params.require(:event).permit(:id, :title, :starttime, :endtime, :frequency, :all_day, :description,
                                  :event_type_id, :private, :proposal_id,
                                  meeting_attributes: [:id,
                                                       place_attributes: %i[id municipality_id address
                                                                            latitude_original longitude_original
                                                                            latitude_center longitude_center zoom]])
  end

  def choose_layout
    @group ? 'groups' : 'open_space'
  end

  private

  def respond_with_ical_index
    calendar = Icalendar::Calendar.new
    @events.each do |event|
      calendar.add_event(event.to_ics)
    end
    calendar.publish
    render text: calendar.to_ical
  end

  def respond_with_json_index
    @events = @events.time_scoped(Time.zone.parse(params['start']), Time.zone.parse(params['end']))
    @events = @events.in_territory(current_domain.territory) unless @group
    events = @events.map { |event| generate_event_obj(event) }
    render json: events.to_json
  end

  def generate_event_obj(event)
    event_obj = event.to_fc
    group = @group || event.groups.first
    if group
      event_obj[:group] = group.name
      event_obj[:group_url] = group_url(group)
    end
    event_obj[:url] = @group ? group_event_url(@group, event) : event_url(event)
    event_obj
  end

  def render_404(exception = nil)
    log_error(exception) if exception
    respond_to do |format|
      @title = t('error.error_404.events.title')
      @message = t('error.error_404.events.description')
      format.html { render 'errors/404', status: 404, layout: true }
    end
    true
  end
end
