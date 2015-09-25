class NotificationEventCreate < NotificationSender
  # new events
  def perform(event_id)
    event = Event.find(event_id)
    @trackable = event
    user = event.user
    organizer = event.groups.first

    if organizer # if there is a group
      data = { event_id: event.id,
               group: organizer.name,
               group_id: organizer.id,
               user_id: user.id,
               event: event.title }
      data[:subdomain] = organizer.subdomain if organizer.certified?

      notification_a = Notification.create(notification_type_id: NotificationType::NEW_EVENTS,
                                           url: group_event_url(organizer, event),
                                           data: data)

      # send an alert to everybody except the one which created the event
      receivers = organizer.participants
    else # public Airesis events
      data = { event_id: event.id, event: event.title, user_id: user.id }
      notification_a = Notification.create(notification_type_id: NotificationType::NEW_PUBLIC_EVENTS,
                                           url: event_url(event),
                                           data: data)
      receivers = User.non_blocking_notification(NotificationType::NEW_PUBLIC_EVENTS)
    end

    receivers.each do |receiver|
      send_notification_to_user(notification_a, receiver) unless receiver == user
    end
  end
end
