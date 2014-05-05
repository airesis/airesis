#encoding: utf-8
class NuovaNotifica < ActiveRecord::Migration
  def up
    I18n.locale = :it

    NotificationType.create( description: "Contributi rimessi in dibattito",email_subject: "Un contributo è stato rimesso in dibattito", notification_category_id: NotificationCategory.find_by_short('MYPROP').id ){ |c| c.id = 25 }.save

    I18n.locale = :us

    NotificationType.find(25).update_attributes(description: "Contributions are put back into debate",email_subject: "A contribution has been putted back in debate")

    I18n.locale = :en

    NotificationType.find(25).update_attributes(description: "Contributions are put back into debate",email_subject: "A contribution has been putted back in debate")

    I18n.locale = :eu

    NotificationType.find(25).update_attributes(description: "Contributions are put back into debate",email_subject: "A contribution has been putted back in debate")

    I18n.locale = :de

    NotificationType.find(25).update_attributes(description: "Beiträge in der Debatte veröffentlicht",email_subject: "Ein Beitrag wurde Debatte wieder")

    I18n.locale = :fr

    NotificationType.find(25).update_attributes(description: "Contributions libérés dans le débat",email_subject: "Une contribution a été rétabli débat")

    I18n.locale = :es

    NotificationType.find(25).update_attributes(description: "Contribuciones liberados en el debate",email_subject: "Una contribución ha sido reintegrado debate")

  end

  def down
  end
end
