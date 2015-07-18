module Abilities
  class Moderator
    include CanCan::Ability

    def initialize(_user)
      can :read, Proposal # can see all the proposals
      can :destroy, ProposalComment do |proposal_comment|
        proposal_comment.grave_reports_count > 0
      end
      can :manage, Announcement

      # can edit participations to group areas
      can [:create, :destroy], AreaParticipation
    end
  end
end
