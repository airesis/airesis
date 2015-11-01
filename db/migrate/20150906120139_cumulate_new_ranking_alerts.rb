class CumulateNewRankingAlerts < ActiveRecord::Migration
  def change
    NotificationType.find_by(name: 'new_valutation').update(cumulable: true)
    NotificationType.find_by(name: 'new_valutation_mine').update(cumulable: true)
  end
end
