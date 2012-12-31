#encoding: utf-8
module AdminHelper
  #cancella le vecchie notifiche
  def self.delete_old_notifications
    msg = "Cancella vecchie notifiche\n"
    count = 0
    deleted = Notification.destroy_all("created_at < '#{-6.month.from_now}' ")
    msg +="Cancello " + deleted.count.to_s + " notifiche più vecchie di 6 mesi"
    count += deleted.count
    read = Notification.destroy_all("notifications.id not in (
                                              select n.id
                                              from notifications n
                                              join user_alerts ua
                                              on n.id = ua.notification_id
                                              where ua.checked = FALSE)
                                              and created_at < '#{-1.month.from_now}'")
    msg +="Cancello " + read.count.to_s + " notifiche già lette più vecchie di 1 mese"                                          
    puts  read.count
    count  += read.count     
    ResqueMailer.admin_message(msg).deliver
    return count
  end
  
  #valida tutti i gruppi presenti a sistema ed invia all'amministratore un elenco di quelli non validi da modificare
  def self.validate_groups  
    msg = "Verifica gruppi\n"
    groups = Group.all
    groups.each do |group|
      if !group.valid?
        msg += group.id.to_s + ": " + group.name + "\n"
        msg += "   " + group.errors.full_messages.join(";") + "\n";
      end
    end
    ResqueMailer.admin_message(msg).deliver
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
      numproposte = user.proposals.all(:conditions => ["proposal_state_id in (?)",[1,2,3,4]]).count
      #numero proposte accettate
      numok = user.proposals.find_all_by_proposal_state_id(6).count
    msg  += "  commenti: " + numcommenti.to_s + "\n"
    msg  += "  proposte: " + numproposte.to_s + "\n"
    msg  += "  proposte accettate: " + numok.to_s + "\n"
    user.rank = numcommenti + 2*(numproposte) + 10*(numok)
    puts "user: "+user.email + " commenti:"+numcommenti.to_s + " proposte:" + numproposte.to_s + " ok:" + numok.to_s + " rank: " + user.rank.to_s
    msg  += "  user rank: " + user.rank.to_s + "\n----\n"
    user.save(:validate => false)
    end
    ResqueMailer.admin_message(msg).deliver
  end
  
  #cambia lo stato delle proposte
  def self.change_proposals_state
    puts "Changing proposal state"
    counter = 0
    denied = 0
    accepted = 0
    #scorri le proposte in votazione che devono essere chiuse
    voting = Proposal.all(:joins => [:vote_period], :conditions => ['proposal_state_id = 4 and current_timestamp > events.endtime'], :readonly => false)
    puts "Proposte da chiudere:" + voting.join(",")
    voting.each do |proposal| #per ciascuna proposta da chiudere
      vote_data = proposal.vote 
      if (!vote_data) #se non ha i dati per la votazione creali
       vote_data = ProposalVote.new(:proposal_id => proposal.id, :positive => 0, :negative => 0, :neutral => 0)
       vote_data.save
      end
      positive = vote_data.positive
      negative = vote_data.negative
      neutral = vote_data.neutral
      votes = positive + negative + neutral
      if (positive > negative)  #se ha avuto più voti positivi allora diventa ACCETTATA
        proposal.proposal_state_id = PROP_ACCEPT
        accepted+=1
      elsif (positive <= negative)  #se ne ha di puù negativi allora diventa RESPINTA
        proposal.proposal_state_id = PROP_RESP
        denied+=1
      end  
     
      proposal.save
    
    end if voting
        
    #prendo tutte le proposte che ad oggi devono essere votate e le passo in stato IN VOTAZIONE
    events = Event.all(:conditions => ['event_type_id = 2 and current_timestamp between starttime and endtime and proposals.proposal_state_id = 3'], :include => [:proposals])
    
    events.each do |event|
      event.proposals.each do |proposal|
        proposal.proposal_state_id = PROP_VOTING
        counter+=1
        proposal.save
        vote_data = proposal.vote 
        if (!vote_data) #se non avesse i dati per la votazione creali
          vote_data = ProposalVote.new(:proposal_id => proposal.id, :positive => 0, :negative => 0, :neutral => 0)
          vote_data.save
        end        
      end
    end if events
    
    msg = denied.to_s + ' proposte sono state RESPINTE, ' + accepted.to_s + ' proposte sono state ACCETTATE, ' + counter.to_s + ' proposte sono passate in VOTAZIONE'
    puts msg
    ResqueMailer.admin_message(msg).deliver
  end
end
