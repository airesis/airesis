class NotificationEventCreate < NotificationSender

  def perform(event_id)
    elaborate(event_id)
  end

  #new events
  def elaborate(event_id)
    event = Event.find(event_id)
    user = event.user
    host = user.locale.host
    organizer = event.groups.first
    if organizer #if there is a group  #todo there are some problems with private and public events and their notifications (???)
      data = {'event_id' => event.id.to_s, 'subject' => "[#{organizer.name}] Nuovo evento: #{event.title}", 'group' => organizer.name, 'group_id' => organizer.id, 'user_id' => user.id, 'event' => event.title, 'i18n' => 't'}
      data['subdomain'] = organizer.subdomain if organizer.certified?

      notification_a = Notification.new(notification_type_id: NotificationType::NEW_EVENTS, url: event_url(event, {host: host}), data: data)
      notification_a.save

      organizer.participants.each do |receiver|
        send_notification_to_user(notification_a, receiver) unless receiver == user #send an alert to everybody except the one which created the event
      end
    else
      data = {'event_id' => event.id.to_s, 'subject' => "Nuovo evento pubblico: #{event.title}", 'event' => event.title, 'user_id' => user.id, 'i18n' => 't'}
      notification_a = Notification.new(notification_type_id: NotificationType::NEW_PUBLIC_EVENTS, url: event_url(event, {host: host}), data: data)
      notification_a.save

      User.where("id not in (#{User.select("users.id").joins(:blocked_alerts).where(blocked_alerts: {notification_type_id: NotificationType::NEW_PUBLIC_EVENTS}).to_sql})").each do |receiver|
        send_notification_to_user(notification_a, user) unless receiver == user
      end
    end
  end
end
