module Abilities
  class Forums
    include CanCan::Ability
    include Abilities::Commons

    def initialize(user)
      forum_permissions(user)
    end

    def forum_permissions(user)
      # forum permissions
      can :read, Frm::Category, group: participate_in_group(user)
      can :read, Frm::Forum, group: participate_in_group(user)

      topic_permissions(user)

      can :moderate, Frm::Forum do |forum|
        user.can_moderate_forem_forum?(forum) || user.forem_admin?(forum.group)
      end

      post_permissions(user)

      forum_admin_permissions(user)
    end

    def topic_permissions(user)
      can :create_topic, Frm::Forum, group: participate_in_group(user)
      can :read, Frm::Topic, forum: { group: participate_in_group(user) }
      can [:create, :update, :destroy, :toggle_hide, :toggle_lock, :toggle_pin], Frm::Topic do |topic|
        topic.forum.group.portavoce.include? user
      end
      can [:new, :create], Frm::Topic, forum: { group: participate_in_group(user) }
      can [:update, :destroy], Frm::Topic, user_id: user.id

      can [:reply, :subscribe, :unsubscribe], Frm::Topic, forum: { group: participate_in_group(user) }
    end

    def forum_admin_permissions(user)
      can :manage, Frm::Category, group: admin_of_group?(user)
      can :manage, Frm::Forum, group: admin_of_group?(user)
      can :manage, Frm::Mod, group: admin_of_group?(user)
    end

    def post_permissions(user)
      can :edit_post, Frm::Forum, group: participate_in_group(user)
      can :create, Frm::Post, group: participate_in_group(user)
      can :update, Frm::Post, user_id: user.id
      can :update, Frm::Post, group: admin_of_group?(user)
      can :destroy, Frm::Post do |post|
        post.owner_or_moderator? user
      end
    end
  end
end
