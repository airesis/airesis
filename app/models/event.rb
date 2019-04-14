class Event < ActiveRecord::Base
  include Concerns::FullCalendable

  attr_accessor :period, :frequency, :commit_button, :proposal_id

  validates_presence_of :title, :description, :starttime, :endtime
  validate :validate_start_time_end_time

  belongs_to :user
  belongs_to :event_type
  has_many :proposals, class_name: 'Proposal', foreign_key: 'vote_period_id'
  has_many :possible_proposals, class_name: 'Proposal', foreign_key: 'vote_event_id'
  has_one :meeting, class_name: 'Meeting', inverse_of: :event, dependent: :destroy
  has_one :place, through: :meeting, class_name: 'Place'
  has_many :meeting_organizations, class_name: 'MeetingOrganization', foreign_key: 'event_id', dependent: :destroy
  has_many :groups, through: :meeting_organizations, class_name: 'Group', source: :group
  has_many :event_comments, class_name: 'EventComment', foreign_key: :event_id, dependent: :destroy

  delegate :meeting_participations, to: :meeting

  accepts_nested_attributes_for :meeting

  before_validation :set_all_day_time

  include Concerns::EventScopes

  after_destroy :remove_scheduled_tasks

  after_commit :send_notifications, on: :create

  REPEATS = ['Non ripetere',
             'Ogni giorno',
             'Ogni settimana',
             'Ogni mese',
             'Ogni anno']

  def valid_dates?
    starttime < endtime
  end

  def validate_start_time_end_time
    return unless starttime && endtime
    errors.add(:starttime, 'La data di inizio deve essere antecedente la data di fine') unless valid_dates?
  end

  # how much does it last the event in seconds
  def duration
    endtime - starttime
  end

  def time_left(ends_at = Time.now)
    amount_seconds = endtime - ends_at # left in seconds
    amount_minutes = amount_seconds / 60.0
    amount_hours = amount_minutes / 60.0
    amount_days = amount_hours / 24.0
    values = [['days', amount_days], ['hours', amount_hours], ['minutes', amount_minutes], ['seconds', amount_seconds]]
    values.each do |unit|
      return I18n.t("time.left.#{unit[0]}", count: unit[1].to_i) if unit[1] >= 1
    end
  end

  def organizer_id=(id)
    meeting_organizations.build(group_id: id) if meeting_organizations.empty?
  end

  def organizer_id
    meeting_organizations.try(:first).try(:group_id)
  end

  def past?
    endtime < Time.now
  end

  def now?
    starttime < Time.now && endtime > Time.now
  end

  def not_started?
    Time.now < starttime
  end

  def votation?
    event_type_id == EventType::VOTATION
  end

  def meeting?
    event_type_id == EventType::MEETING
  end

  def validate
    errors.add_to_base('Start Time must be less than End Time') if (starttime >= endtime) && !all_day
  end

  def to_param
    "#{id}-#{title.downcase.gsub(/[^a-zA-Z0-9]+/, '-').gsub(/-{2,}/, '-').gsub(/^-|-$/, '')}"
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
    self.starttime = starttime.beginning_of_day if starttime
    self.endtime = endtime.end_of_day if endtime
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
    return unless votation?
    EventsWorker.perform_at(starttime, action: EventsWorker::STARTVOTATION, event_id: id)
    EventsWorker.perform_at(endtime, action: EventsWorker::ENDVOTATION, event_id: id)
  end

  def remove_scheduled_tasks
    # Resque.remove_delayed(EventsWorker, {action: EventsWorker::STARTVOTATION, event_id: self.id}) TODO remove job
    # Resque.remove_delayed(EventsWorker, {action: EventsWorker::ENDVOTATION, event_id: self.id}) TODO remove job
  end
end
