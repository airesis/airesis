class AddMisssingAuthFiorAdmin < ActiveRecord::Migration
  def change
    GroupAction.all.each do |group_action|
      ActionAbilitation.create!(group_action: group_action, participation_role: ParticipationRole.find(ParticipationRole::ADMINISTRATOR))
    end
  end
end
