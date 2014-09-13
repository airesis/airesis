class ChangePartecipationToParticipation < ActiveRecord::Migration
  def change
    NotificationType.where(name: 'new_partecipation_request').update_all(name: 'new_participation_request')
  end
end
