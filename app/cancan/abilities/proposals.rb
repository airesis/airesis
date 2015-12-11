module Abilities
  class Proposals
    include CanCan::Ability
    include Abilities::Commons

    def initialize(user)
      proposal_permissions(user)
      proposal_comment_permissions(user)
      proposal_support_permissions(user)
      proposal_presentation_permissions(user)
      proposal_nickname_permissions(user)
    end

    def proposal_support_permissions(user)
      can :new, ProposalSupport
      can :create, ProposalSupport do |support|
        user.groups.include? support.group
      end
    end

    def proposal_presentation_permissions(user)
      # should be you, and proposal must have more users
      can :destroy, ProposalPresentation do |presentation|
        presentation.user == user && presentation.proposal.users.count > 1
      end
    end

    def proposal_nickname_permissions(user)
      can :update, ProposalNickname,
          ["user_id = #{user.id} and created_at > :limit", limit: 10.minutes.ago] do |proposal_nickname|
        proposal_nickname.user_id == user.id && proposal_nickname.created_at > 10.minutes.ago
      end
    end

    def proposal_comment_permissions(user)
      can :unintegrate, ProposalComment, user: { id: user.id }, integrated: true

      # TODO: better check for manage_noise and mark noise permissions
      can [:index, :list, :edit_list, :left_list, :show_all_replies, :manage_noise, :mark_noise], ProposalComment
      can [:show, :history, :report], ProposalComment, user_id: user.id
      can [:show, :history, :report], ProposalComment,
          proposal: { groups: can_do_on_group(user, GroupAction::PROPOSAL_VIEW) }

      create_proposal_comment_permissions(user)

      can :update, ProposalComment, user: { id: user.id }

      can :destroy, ProposalComment do |proposal_comment|
        (proposal_comment.user_id == user.id) &&
          (proposal_comment.created_at > 5.minutes.ago)
      end

      can [:rankup, :rankdown, :ranknil], ProposalComment do |comment|
        can? :participate, comment.proposal
      end
    end

    def create_proposal_comment_permissions(user)
      can :create, ProposalComment, proposal: { private: false }
      can :create, ProposalComment, proposal: { groups: can_do_on_group(user, GroupAction::PROPOSAL_PARTICIPATION) }

      cannot :create, ProposalComment do |_proposal_comment|
        LIMIT_COMMENTS &&
          user.last_proposal_comment && (user.last_proposal_comment.created_at > COMMENTS_TIME_LIMIT.ago)
      end
    end

    def proposal_permissions(user)
      can :destroy, Proposal, groups: admin_of_group?(user)
      can :close_debate, Proposal, proposal_state_id: ProposalState::VALUTATION, groups: admin_of_group?(user)
      can :start_votation, Proposal, proposal_state_id: ProposalState::WAIT, groups: admin_of_group?(user)

      can :create, Proposal do |proposal|
        proposal.group_proposals.empty?
      end
      can :create, Proposal, group_proposals: { group: can_do_on_group(user, GroupAction::PROPOSAL_INSERT) }

      # can see proposals in groups in which has permission, not belonging to any area
      can :show, Proposal, group_proposals: { group: can_do_on_group(user, GroupAction::PROPOSAL_VIEW) }

      # but can't see proposals in presentation areas. it will be allowed in next condition
      cannot :show, Proposal do |proposal|
        proposal.private && !proposal.visible_outside && proposal.presentation_areas.count > 0
      end

      # can see proposals in group areas in which has permission
      can :show, Proposal, presentation_areas: can_do_on_group_area(user, GroupAction::PROPOSAL_VIEW)

      can [:edit, :update, :geocode, :add_authors, :available_authors_list],
          Proposal, users: { id: user.id }, proposal_state_id: ProposalState::VALUTATION

      can [:rankup, :rankdown], Proposal do |proposal|
        ranking = proposal.rankings.find_by(user_id: user.id)
        if ranking
          ranking.updated_at < proposal.updated_at
        else
          can? :participate, proposal
        end
      end

      can :available_author, Proposal do |proposal|
        (proposal.users.exclude? user) &&
          (can? :participate, proposal)
      end

      # he can participate to public proposals
      can :participate, Proposal, private: false
      # in groups
      can :participate, Proposal, group_proposals: { group: can_do_on_group(user, GroupAction::PROPOSAL_PARTICIPATION) }

      # but can't see proposals in presentation areas. it will be allowed in next condition
      cannot :participate, Proposal do |proposal|
        proposal.presentation_areas.count > 0
      end
      # in areas
      can :participate, Proposal, presentation_areas: can_do_on_group_area(user, GroupAction::PROPOSAL_PARTICIPATION)

      # can never participate if not in valutation or voted
      cannot :participate, Proposal,
             proposal_state_id: [ProposalState::WAIT_DATE, ProposalState::WAIT,
                                 ProposalState::VOTING, ProposalState::REVISION, ProposalState::ABANDONED]

      can :vote, Proposal, private: false, proposal_state_id: ProposalState::VOTING

      can :vote, Proposal,
          proposal_state_id: ProposalState::VOTING,
          group_proposals: { group: can_do_on_group(user, GroupAction::PROPOSAL_VOTE) }

      cannot :vote, Proposal do |proposal|
        proposal.presentation_areas.count > 0
      end

      can :vote, Proposal,
          proposal_state_id: ProposalState::VOTING,
          presentation_areas: can_do_on_group_area(user, GroupAction::PROPOSAL_VOTE)

      # can't vote if has already voted
      cannot :vote, Proposal, user_votes: { user_id: user.id }

      can :set_votation_date, Proposal, proposal_state_id: ProposalState::WAIT_DATE, users: { id: user.id }

      can :set_votation_date, Proposal do |proposal| # return true if the user can put the proposal in votation
        (proposal.updated_at < (Time.now - OTHERS_CHOOSE_VOTE_DATE_DAYS.days)) &&
          (!proposal.private? ||
          (proposal.private? &&
            can_do_on_group?(user, proposal.groups.first, GroupAction::PROPOSAL_DATE)))
      end

      can :regenerate, Proposal, proposal_state_id: ProposalState::ABANDONED, private: false
      can :regenerate, Proposal,
          proposal_state_id: ProposalState::ABANDONED,
          group_proposals: { group: can_do_on_group(user, GroupAction::PROPOSAL_INSERT) }

      can :destroy, Proposal do |proposal|
        (proposal.users.include? user) &&
          !(((Time.now - proposal.created_at) > EDIT_PROPOSAL_TIME_LIMIT) &&
            (proposal.valutations > 0 || proposal.proposal_contributes_count > 0)) && proposal.in_valutation?
      end
    end
  end
end
