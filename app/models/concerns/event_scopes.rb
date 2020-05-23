module EventScopes
  extend ActiveSupport::Concern

  included do
    scope :visible, -> { where(private: false) }
    scope :not_visible, -> { where(private: true) }
    scope :votation, -> { where(event_type_id: EventType::VOTATION) }
    scope :after_time, ->(starttime = Time.now) { where('starttime > ?', starttime) }
    scope :vote_period, ->(starttime = Time.now) { votation.after_time(starttime).order('starttime asc') }

    scope :next, -> { where(['endtime > ?', Time.now]) }

    scope :time_scoped, (lambda do |starttime, endtime|
      event_t = Event.arel_table
      where((event_t[:starttime].gteq(starttime).and(event_t[:starttime].lt(endtime))).
          or(event_t[:endtime].gteq(starttime).and(event_t[:endtime].lt(endtime))))
    end)

    scope :in_territory, (lambda do |territory|
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
              else # municipality
                :id
              end
      conditions = (event_t[:event_type_id].eq(EventType::MEETING).and(municipality_t[field].eq(territory.id))).
          or(event_t[:event_type_id].eq(EventType::VOTATION))

      includes(:event_type, place: :municipality).references(:event_type, place: :municipality).where(conditions)
    end)
  end
end
