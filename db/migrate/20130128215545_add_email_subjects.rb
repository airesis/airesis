#encoding: utf-8
class AddEmailSubjects < ActiveRecord::Migration
  def up
    add_column :notification_types, :email_subject, :string, limit: 255
    n = NotificationType.find_by_id(1)
    n.email_subject = "Nuovo commento ad una proposta"
    n.save!

    n = NotificationType.find_by_id(2)
    n.email_subject = "Una proposta è stata aggiornata"
    n.save!

    n = NotificationType.find_by_id(3)
    n.email_subject = "Una nuova proposta è stata inserita"
    n.save!

    n = NotificationType.find_by_id(4)
    n.email_subject = "Una proposta ha cambiato lo stato"
    n.save!

    n = NotificationType.find_by_id(5)
    n.email_subject = "Nuovi commenti ad una proposta"
    n.save!

    n = NotificationType.find_by_id(6)
    n.email_subject = "Una tua proposta ha cambiato lo stato"
    n.save!

    n = NotificationType.find_by_id(7)
    n.email_subject = "Un nuovo sondaggio è stato inserito"
    n.save!

    n = NotificationType.find_by_id(8)
    n.email_subject = "E' presente un nuovo post"
    n.save!

    n = NotificationType.find_by_id(9)
    n.email_subject = "E' presente un nuovo post"
    n.save!

    n = NotificationType.find_by_id(10)
    n.email_subject = "Una nuova proposta è stata inserita"
    n.save!

    n = NotificationType.find_by_id(11)
    n.email_subject = "Una proposta è stata aggiornata"
    n.save!

    n = NotificationType.find_by_id(12)
    n.email_subject = "Nuova richiesta di partecipazione"
    n.save!

    n = NotificationType.find_by_id(13)
    n.email_subject = "Un nuovo evento è stato inserito"
    n.save!

    n = NotificationType.find_by_id(14)
    n.email_subject = "Un nuovo evento è stato inserito"
    n.save!
    n = NotificationType.find_by_id(15)
    n.email_subject = "Un nuovo post è stato inserito"
    n.save!

    n = NotificationType.find_by_id(16)
    n.email_subject = "Una nuova proposta è stata inserita"
    n.save!

    n = NotificationType.find_by_id(17)
    n.email_subject = "Un nuovo sondaggio è stato inserito"
    n.save!
    n = NotificationType.find_by_id(18)
    n.email_subject = "Un nuovo evento è stato inserito"
    n.save!
    n = NotificationType.find_by_id(19)
    n.email_subject = "Un nuovo evento è stato inserito"
    n.save!
    n = NotificationType.find_by_id(20)
    n.email_subject = "Nuova valutazione ad una tua proposta"
    n.save!
    n = NotificationType.find_by_id(21)
    n.email_subject = "Nuova valutazione ad una proposta"
    n.save!

  end

  def down
    remove_column :notification_types, :email_subject
  end
end
