#TODO duplicated code, all that code is duplicated from notification helper. please fix it asap
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

  #delete previous notifications
  def another_delete(attribute, attr_id, user_id, notification_type)
    another = UserAlert.another(attribute, attr_id, user_id, notification_type)
    another.soft_delete_all
  end

  #increase previous notification
  def another_increase_or_do(attribute, attr_id, user_id, notification_type, &block)
    another = UserAlert.another_unread(attribute, attr_id, user_id, notification_type).first
    if another
      another.increase_count!
      PrivatePub.publish_to("/notifications/#{user_id}", pull: 'hello') rescue nil #todo send specific alert to be included
    else
      block.call
    end
  end
end