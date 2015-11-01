class Event < ActiveRecord::Base
  attr_accessor :period, :frequency, :commit_button, :backgroundColor, :textColor, :proposal_id

  validates_presence_of :title, :description, :starttime, :endtime, :event_type, :user
  validate :validate_start_time_end_time

  belongs_to :event_type
  has_many :proposals, class_name: 'Proposal', foreign_key: 'vote_period_id'
  has_many :possible_proposals, class_name: 'Proposal', foreign_key: 'vote_event_id'
  has_one :meeting, class_name: 'Meeting', dependent: :destroy
  has_one :place, through: :meeting, class_name: 'Place'
  has_many :meeting_organizations, class_name: 'MeetingOrganization', foreign_key: 'event_id', dependent: :destroy

  has_many :groups, through: :meeting_organizations, class_name: 'Group', source: :group

  has_many :event_comments, class_name: 'EventComment', foreign_key: :event_id, dependent: :destroy

  belongs_to :user

  delegate :meeting_participations, to: :meeting

  accepts_nested_attributes_for :meeting

  before_validation :set_all_day_time

  scope :visible, -> { where(private: false) }
  scope :not_visible, -> { where(private: true) }
  scope :vote_period, ->(starttime = nil) { where(['event_type_id = ? AND starttime > ?', 2, starttime || Time.now]).order('starttime asc') }

  scope :next, -> { where(['endtime > ?', Time.now]) }

  scope :time_scoped, -> (starttime, endtime) do
    event_t = Event.arel_table
    where((event_t[:starttime].gteq(starttime).and(event_t[:starttime].lt(endtime))).
            or(event_t[:endtime].gteq(starttime).and(event_t[:endtime].lt(endtime))))
  end

  scope :in_territory, ->(territory) do
    municipality_t = Municipality.arel_table
    event_t = Event.arel_table

    field = case territory
            when Continent
              :continent_id
            when Country
              :country_id
            when Region
              :region_id
            when Province
              :province_id
            else # comune
              :id
            end
    conditions = (event_t[:event_type_id].eq(EventType::INCONTRO).and(municipality_t[field].eq(territory.id))).
      or(event_t[:event_type_id].eq(EventType::VOTAZIONE))

    includes(:event_type, place: :municipality).references(:event_type, place: :municipality).where(conditions)
  end

  after_destroy :remove_scheduled_tasks

  after_commit :send_notifications, on: :create

  REPEATS = ['Non ripetere',
             'Ogni giorno',
             'Ogni settimana',
             'Ogni mese',
             'Ogni anno']

  def validate_start_time_end_time
    if starttime && endtime
      errors.add(:starttime, 'La data di inizio deve essere antecedente la data di fine') if endtime <= starttime
    end
  end

  def remove_scheduled_tasks
    # Resque.remove_delayed(EventsWorker, {action: EventsWorker::STARTVOTATION, event_id: self.id}) TODO remove job
    # Resque.remove_delayed(EventsWorker, {action: EventsWorker::ENDVOTATION, event_id: self.id}) TODO remove job
  end

  # how much does it last the event in seconds
  def duration
    endtime - starttime
  end

  def time_left
    amount = endtime - Time.now # left in seconds
    left = I18n.t('time.left.seconds', count: amount.to_i) # TODO: i18n
    if amount >= 60 # if more or equal than 60 seconds left give me minutes
      amount_min = amount / 60
      left = I18n.t('time.left.minutes', count: amount_min.to_i) # TODO: i18n
      if amount_min >= 60 # if more or equal than 60 minutes left give me hours
        amount_hour = amount_min / 60
        left = I18n.t('time.left.hours', count: amount_hour.to_i) # TODO: i18n
        if amount_hour > 24 # if more than 24 hours left give me days
          amount_days = amount_hour / 24
          left = I18n.t('time.left.days', count: amount_days.to_i) # TODO: i18n
        end
      end
    end
    left
  end

  def organizer_id=(id)
    meeting_organizations.build(group_id: id) if meeting_organizations.empty?
  end

  def organizer_id
    meeting_organizations.first.group_id rescue nil
  end

  def is_past?
    endtime < Time.now
  end

  def is_now?
    starttime < Time.now && endtime > Time.now
  end

  def is_not_started?
    Time.now < starttime
  end

  def is_votazione?
    event_type_id == EventType::VOTAZIONE
  end

  def is_incontro?
    event_type_id == EventType::INCONTRO
  end

  def backgroundColor
    event_type.color || '#DFEFFC'
  end

  def textColor
    '#333333'
  end

  def validate
    if (starttime >= endtime) && !all_day
      errors.add_to_base('Start Time must be less than End Time')
    end
  end

  def to_ics
    event = Icalendar::Event.new
    event.dtstart = starttime.strftime('%Y%m%dT%H%M%S')
    event.dtend = endtime.strftime('%Y%m%dT%H%M%S')
    event.summary = title
    event.description = description
    event.created = created_at.strftime('%Y%m%dT%H%M%S')
    event.last_modified = updated_at.strftime('%Y%m%dT%H%M%S')
    event.uid = "#{id}"
    event.url = "#{ENV['SITE']}/events/#{id}"
    event
  end

  def to_fc # fullcalendar format
    { id: id,
      title: title,
      description: description || 'Some cool description here...',
      start: "#{starttime.iso8601}",
      end: "#{endtime.iso8601}",
      allDay: all_day,
      recurring: false,
      backgroundColor: backgroundColor,
      textColor: textColor,
      borderColor: Colors.darken_color(backgroundColor),
      editable: !is_votazione?
    }
  end

  def to_param
    "#{id}-#{title.downcase.gsub(/[^a-zA-Z0-9]+/, '-').gsub(/-{2,}/, '-').gsub(/^-|-$/, '')}"
  end

  def move(minutes_delta = 0, days_delta = 0, all_day = nil)
    self.starttime = minutes_delta.minutes.from_now(days_delta.days.from_now(starttime))
    self.endtime = minutes_delta.minutes.from_now(days_delta.days.from_now(endtime))
    self.all_day = all_day if all_day
    save
  end

  def resize(minutes_delta = 0, days_delta = 0)
    self.endtime = minutes_delta.minutes.from_now(days_delta.days.from_now(endtime))
    save
  end

  # put all attached proposals in votation
  def start_votation
    proposals.each(&:start_votation)
  end

  def end_votation
    proposals.each(&:close_vote_phase)
  end

  def set_all_day_time
    return unless all_day
    self.starttime = starttime.beginning_of_day
    self.endtime = endtime.end_of_day
  end

  def formatted_starttime
    I18n.l starttime, format: all_day? ? :from_long_date : :from_long_date_time
  end

  def formatted_endtime
    I18n.l endtime, format: all_day? ? :until_long_date : :until_long_date_time
  end

  protected

  def send_notifications
    NotificationEventCreate.perform_async(id)

    # timers for start and endtime
    if is_votazione?
      EventsWorker.perform_at(starttime, action: EventsWorker::STARTVOTATION, event_id: id)
      EventsWorker.perform_at(endtime, action: EventsWorker::ENDVOTATION, event_id: id)
    end
  end
end
