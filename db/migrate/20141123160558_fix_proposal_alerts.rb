class FixProposalAlerts < ActiveRecord::Migration
  def change
    wrongs = ProposalAlert.select(:proposal_id, :user_id).group(:proposal_id, :user_id).having('count(*) > 1').pluck(:proposal_id, :user_id)
    wrongs.each do |wrong|
      ProposalAlert.where(proposal_id: wrong[0], user_id: wrong[1]).delete_all
    end
    add_index :proposal_alerts, [:proposal_id, :user_id], unique: true
  end
end
