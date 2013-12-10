class ReorderGroupActions < ActiveRecord::Migration
  def up
    i = 0
    GroupAction.find_by_name('PROPOSAL_VIEW').update_attribute(:seq,i+=1)
    GroupAction.find_by_name('PROPOSAL_PARTECIPATION').update_attribute(:seq,i+=1)
    GroupAction.find_by_name('PROPOSAL_VOTE').update_attribute(:seq,i+=1)
    GroupAction.find_by_name('PROPOSAL_INSERT').update_attribute(:seq,i+=1)
    GroupAction.find_by_name('PROPOSAL').update_attribute(:seq,i+=1)
    GroupAction.find_by_name('DOCUMENT_VIEW').update_attribute(:seq,i+=1)
    GroupAction.find_by_name('DOCUMENT_MANAGE').update_attribute(:seq,i+=1)
    GroupAction.find_by_name('CREATE_EVENT').update_attribute(:seq,i+=1)
    GroupAction.find_by_name('PROPOSAL_DATE').update_attribute(:seq,i+=1)
    GroupAction.find_by_name('STREAM_POST').update_attribute(:seq,i+=1)
    GroupAction.find_by_name('REQUEST_ACCEPT').update_attribute(:seq,i+=1)
  end

  def down
    #dont care
  end
end
