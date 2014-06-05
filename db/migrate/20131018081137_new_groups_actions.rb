class NewGroupsActions < ActiveRecord::Migration
  def up

    i = 0
    GroupAction.find_by_name('STREAM_POST').update_attribute(:seq,i+=1)
    GroupAction.find_by_name('REQUEST_ACCEPT').update_attribute(:seq,i+=1)
    GroupAction.find_by_name('CREATE_EVENT').update_attribute(:seq,i+=1)
    GroupAction.find_by_name('SEND_CANDIDATES').destroy
    GroupAction.find_by_name('PROPOSAL_VIEW').update_attribute(:seq,i+=1)
    GroupAction.find_by_name('PROPOSAL').update_attribute(:seq,i+=1)
    GroupAction.find_by_name('PROPOSAL_PARTICIPATION').update_attribute(:seq,i+=1)
    GroupAction.find_by_name('PROPOSAL_INSERT').update_attribute(:seq,i+=1)
    GroupAction.find_by_name('DOCUMENT_VIEW').update_attribute(:seq,i+=1)
    GroupAction.find_by_name('DOCUMENT_MANAGE').update_attribute(:seq,i+=1)
    GroupAction.find_by_name('PROPOSAL_VOTE').update_attribute(:seq,i+=1)

    GroupAction.create({name: 'PROPOSAL_DATE', seq: i+=1}){|a| a.id = 12}

    ActionAbilitation.where({group_action_id: GroupAction::CREATE_EVENT}).each do |abilitation|
      ActionAbilitation.create({group_action_id: GroupAction::PROPOSAL_DATE, participation_role_id: abilitation.participation_role_id, group_id: abilitation.group_id})
    end

    AreaActionAbilitation.where({group_action_id: GroupAction::CREATE_EVENT}).each do |abilitation|
      AreaActionAbilitation.create({group_action_id: GroupAction::PROPOSAL_DATE, area_role_id: abilitation.area_role_id, group_area_id: abilitation.group_area_id})
    end


  end

  def down
    GroupAction.create({name: 'SEND_CANDIDATES'}){|a| a.id = 5}
    GroupAction.find_by_name('PROPOSAL_DATE').destroy
  end
end
