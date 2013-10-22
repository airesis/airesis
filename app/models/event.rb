#encoding: utf-8
class Event < ActiveRecord::Base

  attr_accessor :period, :frequency, :commit_button, :backgroundColor, :textColor, :proposal_id

  validates_presence_of :title, :description, :starttime, :endtime
  validate :validate_start_time_end_time

  belongs_to :event_series
  belongs_to :event_type
  has_many :proposals, :class_name => 'Proposal', :foreign_key => 'vote_period_id'
  has_one :meeting, :class_name => 'Meeting', :dependent => :destroy
  has_one :place, :through => :meeting, :class_name => 'Place'
  has_many :meeting_organizations, :class_name => 'MeetingOrganization', :foreign_key => 'event_id', :dependent => :destroy
  has_many :organizers, :through => :meeting_organizations, :class_name => 'Group', :source => :group

  has_one :election, :class_name => 'Election', :dependent => :destroy

  has_many :comments, class_name: 'EventComment', foreign_key: :event_id


  accepts_nested_attributes_for :meeting, :election

  scope :public, {:conditions => {private: false}}
  scope :private, {:conditions => {private: true}}
  scope :vote_period, lambda { where(['event_type_id = ? AND starttime > ?', 2, Time.now]).order('starttime asc') }
  scope :in_group, lambda { |group_id| {:include => [:organizers], :conditions => ['groups.id = ?', group_id]} if group_id }

  scope :next, {:conditions => ['starttime > ?', Time.now]}


  after_destroy :remove_scheduled_tasks

  REPEATS = ['Non ripetere',
             'Ogni giorno',
             'Ogni settimana',
             'Ogni mese',
             'Ogni anno']


  def validate_start_time_end_time
    if starttime && endtime
      errors.add(:starttime, "La data di inizio deve essere antecedente la data di fine") if endtime <= starttime
    end

    if event_type_id == EventType::ELEZIONI
      #if election.groups_end_time && election.candidates_end_time
      if election.candidates_end_time
        if  election.candidates_end_time <= starttime ||
            election.candidates_end_time >= endtime
          errors.add(:candidates_end_time, "deve essere compreso tra la data inizio e la data fine dell'evento")
        end
      end
    end
  end

  def remove_scheduled_tasks
    Resque.remove_delayed(EventsWorker, {:action => EventsWorker::STARTVOTATION, :event_id => self.id})
    Resque.remove_delayed(EventsWorker, {:action => EventsWorker::ENDVOTATION, :event_id => self.id})
  end

  #how much does it last the event in seconds
  def duration
    self.endtime - self.starttime
  end

  def time_left

    amount = self.endtime - Time.now #left in seconds
    left = I18n.t('time.left.seconds', count: amount.to_i) #todo:i18n
    if amount >= 60 #if more or equal than 60 seconds left give me minutes
      amount_min = amount/60
      left = I18n.t('time.left.minutes', count: amount_min.to_i) #todo:i18n
      if amount_min >= 60 #if more or equal than 60 minutes left give me hours
        amount_hour = amount_min/60
        left = I18n.t('time.left.hours', count: amount_hour.to_i) #todo:i18n
        if amount_hour > 24 #if more than 24 hours left give me days
          amount_days = amount_hour/24
          left = I18n.t('time.left.days', count: amount_days.to_i) #todo:i18n
        end
      end
    end
    left
  end


  def organizer_id=(id)
    if self.meeting_organizations.empty?
      self.meeting_organizations.build(:group_id => id)
    end
  end

  def organizer_id
    self.meeting_organizations.first.group_id rescue nil
  end

  def is_past?
    Time.now > self.endtime
  end

  def is_now?
    self.starttime < Time.now && self.endtime > Time.now
  end

  def is_not_started?
    Time.now < self.starttime
  end

  def is_elezione?
    self.event_type_id == EventType::ELEZIONI
  end

  def is_votazione?
    self.event_type_id == EventType::VOTAZIONE
  end

  def is_incontro?
    self.event_type_id == EventType::INCONTRO
  end

  def is_riunione?
    self.event_type_id == EventType::RIUNIONE
  end

  def backgroundColor
    "#DFEFFC"
  end

  def textColor
    "#333333"
  end

  def validate
    if (starttime >= endtime) and !all_day
      errors.add_to_base("Start Time must be less than End Time")
    end
  end

  def update_events(events, event)
    events.each do |e|
      begin
        st, et = e.starttime, e.endtime
        e.attributes = event
        if event_series.period.downcase == 'monthly' or event_series.period.downcase == 'yearly'
          nst = DateTime.parse("#{e.starttime.hour}:#{e.starttime.min}:#{e.starttime.sec}, #{e.starttime.day}-#{st.month}-#{st.year}")
          net = DateTime.parse("#{e.endtime.hour}:#{e.endtime.min}:#{e.endtime.sec}, #{e.endtime.day}-#{et.month}-#{et.year}")
        else
          nst = DateTime.parse("#{e.starttime.hour}:#{e.starttime.min}:#{e.starttime.sec}, #{st.day}-#{st.month}-#{st.year}")
          net = DateTime.parse("#{e.endtime.hour}:#{e.endtime.min}:#{e.endtime.sec}, #{et.day}-#{et.month}-#{et.year}")
        end
          #puts "#{nst}           :::::::::          #{net}"
      rescue
        nst = net = nil
      end
      if nst and net
        #          e.attributes = event
        e.starttime, e.endtime = nst, net
        e.save
      end
    end

    event_series.attributes = event
    event_series.save
  end


  def to_ics
    event = Icalendar::Event.new
    event.start = self.starttime.strftime("%Y%m%dT%H%M%S")
    event.end = self.endtime.strftime("%Y%m%dT%H%M%S")
    event.summary = self.title
    event.description = self.description
    event.location = 'Here !'
    event.klass = "PUBLIC"
    event.created = self.created_at.strftime("%Y%m%dT%H%M%S")
    event.last_modified = self.updated_at.strftime("%Y%m%dT%H%M%S")
    event.uid = event.url = "#{Maktoub.home_domain}/events/#{self.id}"
    event.add_comment("AF83 - Shake your digital, we do WowWare")
    event
  end


  def to_param
    "#{id}-#{title.downcase.gsub(/[^a-zA-Z0-9]+/, '-').gsub(/-{2,}/, '-').gsub(/^-|-$/, '')}"
  end

end
