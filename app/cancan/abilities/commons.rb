module Abilities
  module Commons
    def action_hash(user_id, action_id)
      {group_participations: {user_id: user_id,
                              participation_role: {action_abilitations: {group_action_id: action_id}}}}
    end

    def can_do_on_group(user, action)
      {group_participations: {user_id: user.id,
                              participation_role: {action_abilitations: {group_action_id: action}}}}
    end

    def participate_in_group(user)
      {group_participations: {user_id: user.id}}
    end

    def can_do_on_group_area(user, action)
      {area_participations: {user_id: user.id,
                             area_role: {area_action_abilitations: {group_action_id: action}}}}
    end

    def admin_of_group?(user)
      {group_participations: {user_id: user.id,
                              participation_role_id: ParticipationRole.admin.id}}
    end

    def can_do_on_group?(user, group, action)
      group.group_participations.
        joins(participation_role: :action_abilitations).
        where(["group_participations.user_id = :user_id and
                (participation_roles.id = #{ParticipationRole.admin.id} or
                 action_abilitations.group_action_id = :action_id)", user_id: user.id, action_id: action]).uniq.exists?
    end
  end
end
