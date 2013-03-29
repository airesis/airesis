class AddVoteAction < ActiveRecord::Migration
  def up
    GroupAction.create(:name => 'PROPOSAL_VOTE', :description => 'Votare le proposte'){ |c| c.id = 11 }.save
    ActionAbilitation.where(:group_action_id => 7).each do |abilitation|
      ActionAbilitation.create(group_action_id: 11, partecipation_role_id: abilitation.partecipation_role_id, group_id: abilitation.group_id)
    end
  end

  def down
    GroupAction.find_by_name('PROPOSAL_VOTE').destroy
  end
end
