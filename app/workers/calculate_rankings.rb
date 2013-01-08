class CalculateRankings
  
  def self.perform(*args)
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

end
