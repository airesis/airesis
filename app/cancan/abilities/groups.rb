module Abilities
  class Groups
    include CanCan::Ability
    include Abilities::Commons

    def initialize(user)
      group_permissions(user)

      can [:read, :create, :update, :change_group_permission], ParticipationRole, group: admin_of_group?(user)
      can :destroy, ParticipationRole do |participation_role|
        participation_role.id != participation_role.group.participation_role_id
      end

      group_area_permissions(user)

      can [:read, :create, :update, :destroy, :change], AreaRole, group_area: { group: admin_of_group?(user) }

      cannot :destroy, AreaRole do |area_role|
        area_role.id == area_role.group_area.area_role_id
      end

      can :index, [GroupParticipation, GroupArea], group: participate_in_group(user)

      can [:create, :destroy], AreaParticipation, group_area: { group: admin_of_group?(user) }

      # admin of group
      # the rule belongs to the group,
      # the user belongs to the group
      # not changing role of the unique admin
      can :change_user_permission, GroupParticipation do |group_participation|
        puser = group_participation.user
        role = group_participation.participation_role
        group = group_participation.group
        (group.portavoce.include? user) &&
          (!role.group || (role.group == group)) &&
          (!(group.portavoce.include? puser) || (group.portavoce.count > 1))
      end

      can :destroy, GroupParticipation do |group_participation|
        ((group_participation.participation_role_id != ParticipationRole.admin.id ||
          group_participation.group.portavoce.count > 1) &&
          user == group_participation.user) ||
          ((group_participation.group.portavoce.include? user) && (group_participation.user != user))
      end

      can [:new, :create], GroupInvitation, group: can_do_on_group(user, GroupAction::REQUEST_ACCEPT)

      can :index, [GroupParticipation, GroupArea], group: participate_in_group(user)
      can [:read, :dates], [Quorum, BestQuorum, OldQuorum], group: participate_in_group(user)
      can :manage, [Quorum, BestQuorum, OldQuorum], group_quorum: { group: admin_of_group?(user) }
    end

    def group_area_permissions(user)
      can :view_proposal, GroupArea, group: admin_of_group?(user)
      can :view_proposal, GroupArea, can_do_on_group_area(user, GroupAction::PROPOSAL_VIEW)

      can :insert_proposal, GroupArea, group: admin_of_group?(user)
      can :insert_proposal, GroupArea, can_do_on_group_area(user, GroupAction::PROPOSAL_INSERT)

      can :update, GroupArea do |area|
        area.group.portavoce.include? user
      end

      can :manage, GroupArea, group: admin_of_group?(user).merge(enable_areas: true)

      cannot :destroy, GroupArea do |area|
        area.proposals.any?
      end
    end

    def group_permissions(user)
      can :new, Group
      can :create, Group do |_group|
        !LIMIT_GROUPS || !user.portavoce_groups.maximum(:created_at) ||
          (user.portavoce_groups.maximum(:created_at) < GROUPS_TIME_LIMIT.ago)
      end

      can :read, Group
      can [:update, :enable_areas, :change_advanced_options,
           :change_default_anonima, :change_default_visible_outside,
           :change_default_secret_vote], Group, admin_of_group?(user)
      can :create, SearchParticipant, group: participate_in_group(user)

      can :destroy, Group do |group|
        (group.portavoce.include? user) && (group.participants.count < 2)
      end

      can :remove_post, Group, admin_of_group?(user)

      can [:view_documents, :reload_storage_size], Group, can_do_on_group(user, GroupAction::DOCUMENTS_VIEW)
      can :manage_documents, Group, can_do_on_group(user, GroupAction::DOCUMENTS_MANAGE)

      can :post_to, Group, can_do_on_group(user, GroupAction::STREAM_POST)

      can :create_event, Group, can_do_on_group(user, GroupAction::CREATE_EVENT)

      can :support_proposal, Group, can_do_on_group(user, GroupAction::SUPPORT_PROPOSAL)
      can :accept_requests, Group, can_do_on_group(user, GroupAction::REQUEST_ACCEPT)

      can :view_proposal, Group, admin_of_group?(user)
      can :view_proposal, Group, can_do_on_group(user, GroupAction::PROPOSAL_VIEW)

      can :insert_proposal, Group, can_do_on_group(user, GroupAction::PROPOSAL_INSERT)

      can :create_date, Group, can_do_on_group(user, GroupAction::PROPOSAL_DATE)

      can :create_any_event, Group do |group|
        (can? :create_date, group) && (can? :create_event, group)
      end

      can [:view_data, :by_year_and_month, :permissions_list], Group, group_participations: { user_id: user.id }
    end
  end
end
