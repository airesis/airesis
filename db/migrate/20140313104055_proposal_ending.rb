class ProposalEnding < ActiveRecord::Migration
  def up
    NotificationType.create( name: 'proposal_phase_ending', notification_category: NotificationCategory.find_by(short: 'PROP')){ |c| c.id = 30 }.save
  end

  def down
    NotificationType.find(30).destroy
  end
end