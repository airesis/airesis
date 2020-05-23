module FullCalendable
  extend ActiveSupport::Concern

  included do
  end

  def ics_format(time)
    time.strftime('%Y%m%dT%H%M%S')
  end

  def ics_starttime
    ics_format(starttime)
  end

  def ics_endtime
    ics_format(endtime)
  end

  def ics_created_at
    ics_format(created_at)
  end

  def ics_updated_at
    ics_format(updated_at)
  end

  def background_color
    event_type.color || '#DFEFFC'
  end

  def text_color
    '#333333'
  end

  def to_ics
    event = Icalendar::Event.new
    event.dtstart = ics_starttime
    event.dtend = ics_endtime
    event.summary = title
    event.description = description
    event.created = ics_created_at
    event.last_modified = ics_updated_at
    event.uid = "#{id}"
    event.url = "#{ENV['SITE']}/events/#{id}"
    event
  end

  def to_fc # fullcalendar format
    { id: id,
      title: title, description: description || 'Some cool description here...',
      start: "#{starttime.iso8601}", end: "#{endtime.iso8601}", allDay: all_day,
      recurring: false,
      backgroundColor: background_color, textColor: text_color, borderColor: Colors.darken_color(background_color),
      editable: !votation?
    }
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
end
