module Abilities
  class Events
    include CanCan::Ability
    include Abilities::Commons

    def initialize(user)
      events_permissions(user)
    end

    def events_permissions(user)
      # can also view private events of groups in which participates
      can :read, Event, groups: participate_in_group(user)

      can :create, Event

      can %i[update destroy], Event, user_id: user.id # can update my event
      can %i[update destroy], Event, groups: admin_of_group?(user)
      cannot [:update, :destroy], Event do |event|
        event.proposals.any? || event.possible_proposals.any?
      end

      event_comments_permissions(user)
      meeting_participations_permissions(user)
    end

    def meeting_participations_permissions(user)
      can :create, MeetingParticipation, meeting: { event: { private: false } }
      can :create, MeetingParticipation, meeting: { event: { groups: participate_in_group(user) } }
      cannot :create, MeetingParticipation, meeting: { event: ['endtime < :limit', limit: Time.zone.now] }
    end

    def event_comments_permissions(user)
      can %i[create like], EventComment, event: { groups: participate_in_group(user) }
      can %i[create like], EventComment, event: { private: false }

      can :destroy, EventComment, user_id: user.id
    end
  end
end
