class NotificationEventCreate < NotificationSender
  include Sidekiq::Worker, GroupsHelper, Rails.application.routes.url_helpers

  def perform(current_user_id,event_id)
    elaborate(current_user_id,event_id)
  end

  #invia le notifiche quando un una proposta viene creata
  def elaborate(current_user_id,event_id)
    event = Event.find(event_id)
    current_user = User.find(current_user_id)
    host = current_user.locale.host
    organizer = event.organizers.first
    if organizer  #if there is a group  #todo there are some problems with private and public events and their notifications
      data = {'event_id' => event.id.to_s, 'subject' => "[#{organizer.name}] Nuovo evento: #{event.title}", 'group' => organizer.name,'group_id' => organizer.id,'user_id' => current_user_id, 'event' => event.title, 'i18n' => 't'}
      data['subdomain'] = organizer.subdomain if organizer.certified?

      notification_a = Notification.new(notification_type_id: NotificationType::NEW_EVENTS, :url => event_url(event,{host: host}), data: data)
      notification_a.save

      organizer.partecipants.each do |user|
        unless user == current_user #invia la notifica a tutti tranne a chi ha creato l'evento
          send_notification_to_user(notification_a, user)
        end
      end
    else
      data = {'event_id' => event.id.to_s, 'subject' => "Nuovo evento pubblico: #{event.title}", 'event' => event.title, 'user_id' => current_user_id, 'i18n' => 't'}
      notification_a = Notification.new(notification_type_id: NotificationType::NEW_PUBLIC_EVENTS, url: event_url(event,{host: host}), data: data)
      notification_a.save

      User.where("id not in (#{User.select("users.id").joins(:blocked_alerts).where("blocked_alerts.notification_type_id = #{NotificationType::NEW_PUBLIC_EVENTS}").to_sql})").each do |user|
        unless user == current_user #invia la notifica a tutti tranne a chi ha creato l'evento
          send_notification_to_user(notification_a, user)
        end
      end
    end
  end
end