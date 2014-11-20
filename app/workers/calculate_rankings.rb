class CalculateRankings
  include Sidekiq::Worker
  sidekiq_options queue: :low_priority

  def perform(*args)
    msg = "Ricalcolo ranking\n"
    @users = User.all
    @users.each do |user|
      msg += " " + user.fullname + "\n"
      #numero di commenti inseriti
      numcommenti = user.proposal_comments.count
      #numero di proposte inserite (tranne quelle bocciate)
      numproposte = user.proposals.where("proposal_state_id in (?)",[1,2,3,4]).count
      #numero proposte accettate
      numok = user.proposals.where(proposal_state_id: 6).count
      msg  += "  commenti: " + numcommenti.to_s + "\n"
      msg  += "  proposte: " + numproposte.to_s + "\n"
      msg  += "  proposte accettate: " + numok.to_s + "\n"
      user.rank = numcommenti + 2*(numproposte) + 10*(numok)
      msg  += "  user rank: " + user.rank.to_s + "\n----\n"
      user.save(validate: false)
    end
    ResqueMailer.delay.admin_message(msg)
  end

end
