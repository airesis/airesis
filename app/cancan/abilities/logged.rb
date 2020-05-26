module Abilities
  class Logged
    include CanCan::Ability
    include Abilities::Commons

    def initialize(user)
      user_profile_permissions(user)

      merge Abilities::Proposals.new(user)
      merge Abilities::Groups.new(user)

      user_message_permissions(user)

      can %i[read dates], [Quorum, BestQuorum, OldQuorum], public: true

      merge Abilities::Blogs.new(user)
      merge Abilities::Events.new(user)
      merge Abilities::Forums.new(user)

      ckeditor_permissions(user)
    end

    def user_profile_permissions(user)
      can :show_tooltips, User, show_tooltips: true
      can :change_rotp_enabled, User if user.email
      can %i[read check], Alert, user_id: user.id

      # can destroy an identity provider only if he has a valid email address
      can :destroy, Authentication do |authentication|
        user == authentication.user && user.email
      end
    end

    def ckeditor_permissions(user)
      can :access, :ckeditor # needed to access Ckeditor filebrowser
      can %i[read create destroy], Ckeditor::Picture, assetable_id: user.id
      can %i[read create destroy], Ckeditor::AttachmentFile, assetable_id: user.id
    end

    def user_message_permissions(user)
      return if user.email.blank? # must have an email

      # can send messages if receiver has enabled it
      can :send_message, User, receive_messages: true
      # can't send messages if receiver has not an email address
      cannot :send_message, User, email: nil
      # cannot send messages to himself
      cannot :send_message, User, id: user.id
    end
  end
end
