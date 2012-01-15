module NotificationHelper
  
  #invia una notifica ad un utente.
  #se l'utente ha bloccato il tipo di notifica allora non viene inviata
  #se l'utente ha abilitato anche l'invio via mail allora viene inviata via mail TODO
  def send_notification_to_user(notification,user)
     if (!user.blocked_notifications.include?notification.notification_type) #se il tipo nnon è bloccato
      alert = UserAlert.new(:user_id => user.id, :notification_id => notification.id, :checked => false);
      alert.save #invia la notifica
      if false
        CronMailer.notification_email(alert).deliver
      end
     end
  end
  
  
  #invia le notifiche quando un utente valuta la proposta
  #le notifiche vengono inviate ai creatori e ai partecipanti alla proposta
  def user_valutate_proposal(proposal_ranking)
    proposal = proposal_ranking.proposal
    msg = "La tua proposta <b>"+proposal.title+"</b> ha ricevuto una nuova valutazione!";
      notification_a = Notification.new(:notification_type_id => 20,:message => msg, :url => proposal_path(proposal))
      notification_a.save
    proposal.users.each do |user|
      if (user != proposal_ranking.user)
        alert = UserAlert.new(:user_id => user.id, :notification_id => notification_a.id, :checked => false);
        alert.save
      end
    end
    msg = "La proposta <b>"+proposal.title+"</b> ha ricevuto una nuova valutazione!";
    notification_b = Notification.create(:notification_type_id => 21,:message => msg,:url => proposal_path(proposal))
    proposal.partecipants.each do |user|
      if ((user != proposal_ranking.user) && (!proposal.users.include?user))
        UserAlert.create(:user_id => user.id, :notification_id => notification_b.id, :checked => false);
      end
    end
    
  end

  #invia le notifiche quando un utente inserisce un commento alla proposta
  #le notifiche vengono inviate ai creatori e ai partecipanti alla proposta
  def user_comment_proposal(comment)
    proposal = comment.proposal
    comment_user = comment.user
    msg = "<b>"+ comment_user.name + " " + comment_user.surname + "</b> ha inserito un commento alla tua proposta <b>"+proposal.title+"</b>!";
      notification_a = Notification.new(:notification_type_id => 5,:message => msg, :url => proposal_path(proposal) +"#comment"+comment.id.to_s)
      notification_a.save
    proposal.users.each do |user|
      if (user != comment_user)
        alert = UserAlert.new(:user_id => user.id, :notification_id => notification_a.id, :checked => false);
        alert.save
      end
    end
    
    msg = "<b>"+ comment_user.name + " " + comment_user.surname + "</b> ha inserito un commento alla proposta <b>"+proposal.title+"</b>!";
    notification_b = Notification.create(:notification_type_id => 1,:message => msg,:url => proposal_path(proposal) +"#comment"+comment.id.to_s)
    proposal.partecipants.each do |user|
      if ((user != comment_user) && (!proposal.users.include?user))
        UserAlert.create(:user_id => user.id, :notification_id => notification_b.id, :checked => false);
      end
    end
    
  end
end
