class GroupDefaultRole < ActiveRecord::Migration
  def up
    Group.all(:conditions => {:partecipation_role_id => 1}).each do |group|
      group.default_role_name = 'iscritti'
      role = group.partecipation_roles.build({name: group.default_role_name, description: 'Ruolo predefinito del gruppo'})
      DEFAULT_GROUP_ACTIONS.each do |action_id|
        abilitation = role.action_abilitations.build(group_action_id: action_id, group_id: group.id)
      end
      role.save!
      group.partecipation_role_id = role.id
      group.save!

      group.group_partecipations.each do |partecipation|
        if (partecipation.partecipation_role_id == 1)
          partecipation.update_attribute(:partecipation_role_id,role.id)
        end
      end

    end
  end

  def down
    Group.joins(:default_role).readonly(false).all(:conditions => "partecipation_roles.name = 'iscritti'").each do |group|
      role = group.default_role
      group.partecipation_role_id = 1
      group.default_role_name = nil
      group.save!(:validate => false)
      role.destroy
    end
  end
end
