class NotificationEventCreate < NotificationSender
  include GroupsHelper, Rails.application.routes.url_helpers

  @queue = :notifications

  def self.perform(current_user_id,event_id)
    NotificationEventCreate.new.elaborate(current_user_id,event_id)

  end

  #invia le notifiche quando un una proposta viene creata
  def elaborate(current_user_id,event_id)
    event = Event.find(event_id)
    current_user = User.find(current_user_id)
    if event.private
      organizer = event.organizers.first
      data = {'event_id' => event.id.to_s, 'subject' => "[#{organizer.name}] Nuovo evento: #{event.title}", 'group' => organizer.name, 'event' => event.title, 'i18n' => 't'}
      notification_a = Notification.new(notification_type_id: NotificationType::NEW_EVENTS, :url => event_url(event), data: data)
      notification_a.save

      organizer.partecipants.each do |user|
        unless user == current_user #invia la notifica a tutti tranne a chi ha creato l'evento
          send_notification_to_user(notification_a, user)
        end
      end
    else
      data = {'event_id' => event.id.to_s, 'subject' => "Nuovo evento pubblico: #{event.title}", 'event' => event.title, 'i18n' => 't'}
      notification_a = Notification.new(notification_type_id: NotificationType::NEW_PUBLIC_EVENTS, url: event_url(event), data: data)
      notification_a.save

      User.where("id not in (#{User.select("users.id").joins(:blocked_alerts).where("blocked_alerts.notification_type_id = #{NotificationType::NEW_PUBLIC_EVENTS}").to_sql})").each do |user|
        unless user == current_user #invia la notifica a tutti tranne a chi ha creato l'evento
          send_notification_to_user(notification_a, user)
        end
      end
    end
  end
end