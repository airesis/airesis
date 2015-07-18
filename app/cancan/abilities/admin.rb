module Abilities
  class Admin
    include CanCan::Ability

    def initialize(_user)
      # can close debate of a proposal
      can :close_debate, Proposal, proposal_state_id: ProposalState::VALUTATION
      can :start_votation, Proposal, proposal_state_id: ProposalState::WAIT

      # can send messages to every user although they denied it
      can :send_message, User

      can [:set_votation_date, :participate, :edit, :update, :geocode, :add_authors, :destroy], Proposal
      can [:read, :create, :update, :change_group_permission], ParticipationRole
      can :index, SysPaymentNotification
      can :create_topic, Frm::Forum
      can :index, GroupParticipation
      management
      forbidden_actions
    end

    def management
      can :manage, [ProposalComment, Group, GroupArea, ParticipationRole, AreaRole, Blog, BlogPost, Quorum, Event]
      can :manage, [Frm::Category, Frm::Forum, Frm::Topic, Frm::Post]
      can :manage, [Newsletter, SysLocale]
    end

    def forbidden_actions
      cannot :destroy, ParticipationRole do |participation_role|
        participation_role.id == participation_role.group.participation_role_id
      end
      cannot :destroy, AreaRole do |area_role|
        area_role.id == area_role.group_area.area_role_id
      end
    end
  end
end
