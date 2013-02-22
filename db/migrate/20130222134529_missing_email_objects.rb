#encoding: utf-8
class MissingEmailObjects < ActiveRecord::Migration
  def up
    n = NotificationType.find_by_id(22)
    n.email_subject = "Un utente si è reso disponibile a redigere la sintesi di una proposta"
    n.save!
    n = NotificationType.find_by_id(23)
    n.email_subject = "Sei stato scelto come redattore di una proposta"
    n.save!
    n = NotificationType.find_by_id(24)
    n.email_subject = "Nuovi redattori per una proposta"
    n.save!
  end

  def down
  end
end
