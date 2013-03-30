class OrderGroupActions < ActiveRecord::Migration
  def up
    add_column :group_actions, :seq, :integer
    GroupAction.find_by_name('STREAM_POST').update_attribute(:seq,1)
    GroupAction.find_by_name('CREATE_EVENT').update_attribute(:seq,2)
    GroupAction.find_by_name('PROPOSAL').update_attribute(:seq,3)
    GroupAction.find_by_name('REQUEST_ACCEPT').update_attribute(:seq,4)
    GroupAction.find_by_name('SEND_CANDIDATES').update_attribute(:seq,5)
    GroupAction.find_by_name('PROPOSAL_VIEW').update_attribute(:seq,6)
    GroupAction.find_by_name('PROPOSAL_PARTECIPATION').update_attribute(:seq,8)
    GroupAction.find_by_name('PROPOSAL_VOTE').update_attribute(:seq,9)
    GroupAction.find_by_name('PROPOSAL_INSERT').update_attribute(:seq,7)
    GroupAction.find_by_name('DOCUMENT_VIEW').update_attribute(:seq,10)
    GroupAction.find_by_name('DOCUMENT_MANAGE').update_attribute(:seq,11)
  end

  def down
    remove_column :group_actions, :seq
  end
end
