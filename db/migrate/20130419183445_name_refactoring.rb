class NameRefactoring < ActiveRecord::Migration
  def up
    NotificationType.find(1).update_attribute(:email_subject, 'Nuovo contributo ad una proposta')
    NotificationType.find(5).update_attribute(:description, 'Nuovi contributi alle mie proposte')
    NotificationType.find(5).update_attribute(:email_subject, 'Nuovo contributo ad una mia proposta')
    NotificationType.find(18).update_attribute(:email_subject, 'Nuovo contributo di un utente che seguo')
  end

  def down
  end
end
