class NotificationSender

    
  protected

  #invia una notifica ad un utente.
  #se l'utente ha bloccato il tipo di notifica allora non viene inviata
  #se l'utente ha abilitato anche l'invio via mail allora viene inviata via mail
  def send_notification_to_user(notification,user)
    unless user.blocked_notifications.include?notification.notification_type #se il tipo non è bloccato
      alert = UserAlert.new(:user_id => user.id, :notification_id => notification.id, :checked => false)
      alert.save! #invia la notifica
      res = PrivatePub.publish_to("/notifications/#{user.id}", pull: 'hello') rescue nil  #todo send specific alert to be included
    end
    true
  end
end