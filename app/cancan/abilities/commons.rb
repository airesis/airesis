module Abilities
  module Commons
    def action_hash(user_id, action_id)
      { group_participations: { user_id: user_id,
                                participation_role: { action_id => true } } }
    end

    def can_do_on_group(user, action)
      { group_participations: { user_id: user.id,
                                participation_role: { action => true } } }
    end

    def participate_in_group(user)
      { group_participations: { user_id: user.id } }
    end

    def can_do_on_group_area(user, action)
      { area_participations: { user_id: user.id,
                               area_role: { action => true } } }
    end

    def admin_of_group?(user)
      { group_participations: { user_id: user.id,
                                participation_role_id: ParticipationRole.admin.id } }
    end

    def can_do_on_group?(user, group, action)
      group.group_participations.
        joins(:participation_role).
        where(["group_participations.user_id = :user_id AND
                (participation_roles.id = #{ParticipationRole.admin.id} OR
                 participation_roles.#{action} = true)", user_id: user.id]).distinct.exists?
    end
  end
end
