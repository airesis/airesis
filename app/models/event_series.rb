class EventSeries < ActiveRecord::Base
  attr_accessor :title, :description, :commit_button, :event_type_id, :organizer_id, :meeting_attributes

  validates_presence_of :frequency, :period, :starttime, :endtime
  validates_presence_of :title, :description
  validate :validate_start_time_before_end_time

  has_many :events, dependent: :destroy

  after_create :create_until_end

  after_initialize :initilize_me

  def initilize_me
    puts 'Hi man'
  end


  def validate_start_time_before_end_time
    if starttime && endtime
      errors.add(:starttime, 'La data di inizio deve essere antecedente la data di fine') if endtime < starttime
    end
  end


  def create_until_end
    create_events_until(END_TIME)
  end

  def create_events_until(end_time)
    st = starttime
    et = endtime
    p = r_period(period)
    nst, net = st, et

    while frequency.send(p).from_now(st) <= end_time
#      puts "#{nst}           :::::::::          #{net}" if nst and net
      self.events.create(title: title, description: description, all_day: all_day, starttime: nst, endtime: net, event_type_id: event_type_id, meeting_attributes: self.meeting_attributes, organizer_id: self.organizer_id)
      nst = st = frequency.send(p).from_now(st)
      net = et = frequency.send(p).from_now(et)

      if period.downcase == 'monthly' or period.downcase == 'yearly'
        begin
          nst = DateTime.parse("#{starttime.hour}:#{starttime.min}:#{starttime.sec}, #{starttime.day}-#{st.month}-#{st.year}")
          net = DateTime.parse("#{endtime.hour}:#{endtime.min}:#{endtime.sec}, #{endtime.day}-#{et.month}-#{et.year}")
        rescue
          nst = net = nil
        end
      end
    end
  end

  def r_period(period)
    case period
      when 'Ogni giorno'
        p = 'days'
      when 'Ogni settimana'
        p = 'weeks'
      when 'Ogni mese'
        p = 'months'
      when 'Ogni anno'
        p = 'years'
    end
    return p
  end

end
