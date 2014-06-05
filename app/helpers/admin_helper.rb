#encoding: utf-8
module AdminHelper

  #cancella le vecchie notifiche
  def self.delete_old_notifications
    msg = "Cancella vecchie notifiche\n"
    count = 0
    deleted = Notification.destroy_all(["created_at < ?",-6.month.from_now])
    msg +="Cancello " + deleted.count.to_s + " notifiche più vecchie di 6 mesi"
    count += deleted.count
    read = Notification.destroy_all(["notifications.id not in (
                                              select n.id
                                              from notifications n
                                              join alerts ua
                                              on n.id = ua.notification_id
                                              where ua.checked = FALSE)
                                              and created_at < ?",-1.month.from_now])
    msg +="Cancello " + read.count.to_s + " notifiche già lette più vecchie di 1 mese"
    count  += read.count     
    ResqueMailer.delay.admin_message(msg)
    return count
  end
  
  #valida tutti i gruppi presenti a sistema ed invia all'amministratore un elenco di quelli non validi da modificare
  def self.validate_groups  
    msg = "Verifica gruppi\n"
    groups = Group.all
    groups.each do |group|
      if !group.valid?
        msg += group.id.to_s + ": " + group.name + "\n"
        msg += "   " + group.errors.full_messages.join(";") + "\n"
      end
    end
    ResqueMailer.delay.admin_message(msg)
  end
  
  #calcola il ranking degli utenti
  def self.calculate_ranking  
    msg = "Ricalcolo ranking\n"
    @users = User.all
    @users.each do |user|
      msg += " " + user.email + "\n"
      #numero di commenti inseriti
      numcommenti = user.proposal_comments.count
      #numero di proposte inserite (tranne quelle bocciate)
      numproposte = user.proposals.all(conditions: ["proposal_state_id in (?)",[1,2,3,4]]).count
      #numero proposte accettate
      numok = user.proposals.find_all_by_proposal_state_id(6).count
    msg  += "  commenti: " + numcommenti.to_s + "\n"
    msg  += "  proposte: " + numproposte.to_s + "\n"
    msg  += "  proposte accettate: " + numok.to_s + "\n"
    user.rank = numcommenti + 2*(numproposte) + 10*(numok)
    puts "user: "+user.email + " commenti:"+numcommenti.to_s + " proposte:" + numproposte.to_s + " ok:" + numok.to_s + " rank: " + user.rank.to_s
    msg  += "  user rank: " + user.rank.to_s + "\n----\n"
    user.save(validate: false)
    end
    ResqueMailer.delay.admin_message(msg)
  end

end
