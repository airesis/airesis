#encoding: utf-8
class Ability
  include CanCan::Ability

  def action_hash(user_id, action_id)
    {group_participations: {user_id: user_id, participation_role: {action_abilitations: {group_action_id: action_id}}}}
  end

  def initialize(user)
    can [:index, :show, :read], [Blog, Group]
    can :view_data, Group, private: false
    can :read, Frm::Category, visible_outside: true
    can :read, Frm::Forum, visible_outside: true, category: {visible_outside: true}
    can :read, Frm::Topic, forum: {visible_outside: true, category: {visible_outside: true}}
    can :read, Event, private: false
    can :read, BlogPost, status: BlogPost::PUBLISHED
    can :index, Proposal
    can :show, Proposal, private: false
    can :read, ProposalComment, proposal: {private: false}
    can :show, Proposal, visible_outside: true
    can :read, Announcement, ["starts_at <= :now and ends_at >= :now", now: Time.zone.now] do |a|
      true
    end
    if user

      can :create, Proposal, group_proposals: {group: {group_participations: {user_id: user.id, participation_role: {action_abilitations: {group_action_id: GroupAction::PROPOSAL_INSERT}}}}}

      #can see proposals in groups in which has permission, not belonging to any area
      can :show, Proposal, group_proposals: {group: {group_participations: {user_id: user.id, participation_role: {action_abilitations: {group_action_id: GroupAction::PROPOSAL_VIEW}}}}}

      #but can't see all proposals in presentation area
      #cannot :show, Proposal, presentation_areas: [area_participations: {user_id}]

      #can see proposals in group areas in which has permission
      can :show, Proposal, presentation_areas: {area_participations: {user_id: user.id, area_role: {area_action_abilitations: {group_action_id: GroupAction::PROPOSAL_VIEW}}}}

      can [:edit, :update], Proposal, users: {id: user.id}, proposal_state_id: ProposalState::VALUTATION

      #he can participate to public proposals
      can :participate, Proposal, private: false
      #in groups
      can :participate, Proposal, group_proposals: {group: {group_participations: {user_id: user.id, participation_role: {action_abilitations: {group_action_id: GroupAction::PROPOSAL_PARTICIPATION}}}}}
      #in areas
      can :participate, Proposal, presentation_areas: {area_participations: {user_id: user.id, area_role: {area_action_abilitations: {group_action_id: GroupAction::PROPOSAL_PARTICIPATION}}}}

      #can never participate if not in valutation or voted
      cannot :participate, Proposal, proposal_state_id: [ProposalState::WAIT_DATE, ProposalState::WAIT, ProposalState::VOTING, ProposalState::REVISION, ProposalState::ABANDONED]


      can :vote, Proposal, private: false, proposal_state_id: ProposalState::VOTING
      can :vote, Proposal, proposal_state_id: ProposalState::VOTING, group_proposals: {group: {group_participations: {user_id: user.id, participation_role: {action_abilitations: {group_action_id: GroupAction::PROPOSAL_VOTE}}}}}
      can :vote, Proposal, proposal_state_id: ProposalState::VOTING, presentation_areas: {area_participations: {user_id: user.id, area_role: {area_action_abilitations: {group_action_id: GroupAction::PROPOSAL_PARTICIPATION}}}}
      cannot :vote, Proposal, user_votes: {user_id: user.id}

      can :set_votation_date, Proposal, proposal_state_id: ProposalState::WAIT_DATE, users: {id: user.id}

      can :set_votation_date, Proposal do |proposal| #return true if the user can put the proposal in votation
        (proposal.updated_at < (Time.now - 5.days)) &&
            proposal.private? &&
            can_do_on_group?(user, proposal.groups.first, GroupAction::PROPOSAL_DATE)
      end

      can :regenerate, Proposal, proposal_state_id: ProposalState::ABANDONED, private: false
      can :regenerate, Proposal, proposal_state_id: ProposalState::ABANDONED, group_proposals: {group: {group_participations: {user_id: user.id, participation_role: {action_abilitations: {group_action_id: GroupAction::PROPOSAL_INSERT}}}}}

      #it's by block cause of count()
      can :destroy, Proposal do |proposal|
        (proposal.users.include? user) &&
            !(((Time.now - proposal.created_at) > 10.minutes) && (proposal.valutations > 0 || proposal.contributes.count > 0)) &&
            proposal.in_valutation?
      end

      can :unintegrate, ProposalComment, user: {id: user.id}, integrated: true

      can [:index, :list, :edit_list, :left_list], ProposalComment
      can :show, ProposalComment, user_id: user.id
      can :show, ProposalComment, proposal: {groups: {group_participations: {user_id: user.id, participation_role: {action_abilitations: {group_action_id: GroupAction::PROPOSAL_VIEW}}}}}
      can :create, ProposalComment, proposal: {groups: {group_participations: {user_id: user.id, participation_role: {action_abilitations: {group_action_id: GroupAction::PROPOSAL_PARTICIPATION}}}}}

      can :update, ProposalComment, user: {id: user.id}

      can :destroy, ProposalComment do |proposal_comment|
        (proposal_comment.user_id = user.id) &&
            (proposal_comment.created_at > 5.minutes.ago)
      end

      can :rank, ProposalComment do |comment|
        can? :participate, comment.proposal
      end

      can :new, ProposalSupport
      can :create, ProposalSupport do |support|
        user.groups.include? support.group
      end
      can :create, Group do |group|
        !LIMIT_GROUPS ||
            (user.portavoce_groups.maximum(:created_at) &&
                (user.portavoce_groups.maximum(:created_at) > GROUPS_TIME_LIMIT.ago))
      end

      can :read, Group
      can :update, Group, group_participations: {user_id: user.id, participation_role_id: ParticipationRole::ADMINISTRATOR}

      can :destroy, Group do |group|
        (group.portavoce.include? user) && (group.participants.count < 2)
      end

      can :remove_post, Group, group_participations: {user_id: user.id, participation_role_id: ParticipationRole::ADMINISTRATOR}

      can :view_documents, Group, group_participations: {user_id: user.id, participation_role: {action_abilitations: {group_action_id: GroupAction::DOCUMENTS_VIEW}}}
      can :manage_documents, Group, group_participations: {user_id: user.id, participation_role: {action_abilitations: {group_action_id: GroupAction::DOCUMENTS_MANAGE}}}

      can :post_to, Group, group_participations: {user_id: user.id, participation_role: {action_abilitations: {group_action_id: GroupAction::STREAM_POST}}}

      can :create_event, Group, group_participations: {user_id: user.id, participation_role: {action_abilitations: {group_action_id: GroupAction::CREATE_EVENT}}}

      can :support_proposal, Group, group_participations: {user_id: user.id, participation_role: {action_abilitations: {group_action_id: GroupAction::SUPPORT_PROPOSAL}}}
      can :accept_requests, Group, group_participations: {user_id: user.id, participation_role: {action_abilitations: {group_action_id: GroupAction::REQUEST_ACCEPT}}}

      can :view_proposal, Group, group_participations: {user_id: user.id, participation_role_id: ParticipationRole::ADMINISTRATOR}
      can :view_proposal, Group, group_participations: {user_id: user.id, participation_role: {action_abilitations: {group_action_id: GroupAction::PROPOSAL_VIEW}}}

      can :insert_proposal, Group, group_participations: {user_id: user.id, participation_role: {action_abilitations: {group_action_id: GroupAction::PROPOSAL_INSERT}}}

      can :create_date, Group, group_participations: {user_id: user.id, participation_role: {action_abilitations: {group_action_id: GroupAction::PROPOSAL_DATE}}}

      can :create_any_event, Group do |group|
        (can? :create_date, group) && (can? :create_event, group)
      end

      can :view_data, Group, private: false
      can :view_data, Group, group_participations: {user: {id: user.id}}

      can [:read, :create, :update, :change_group_permission], ParticipationRole, group_id: user.portavoce_group_ids

      can :destroy, ParticipationRole do |participation_role|
        participation_role.id != participation_role.group.participation_role_id
      end

      can :update, AreaRole do |area_role|
        area_role.group_area.group.portavoce.include? user
      end

      can :view_proposal, GroupArea, area_participations: {user_id: user.id, area_role: {area_action_abilitations: {group_action_id: GroupAction::PROPOSAL_VIEW}}}
      can :insert_proposal, GroupArea, area_participations: {user_id: user.id, area_role: {area_action_abilitations: {group_action_id: GroupAction::PROPOSAL_INSERT}}}

      can :update, GroupArea do |area|
        area.group.portavoce.include? user
      end
      can :destroy, GroupArea do |area|
        (area.group.portavoce.include? user) && (area.proposals.count == 0)
      end

      can :read, Election do |election|
        group = election.groups.first
        group.participants.include? user #posso visualizzare un'elezione solo se appartengo al gruppo
      end
      can :vote, Election do |election|
        group = election.groups.first
        group.participants.include? user #posso visualizzare un'elezione solo se appartengo al gruppo
      end

      #should be you, and proposal must have more users
      can :destroy, ProposalPresentation do |presentation|
        presentation.user == user &&
            presentation.proposal.users.count > 1
      end


      can :show_tooltips, User, show_tooltips: true

      #must have an email
      if user.email
        #can send messages if receiver has enabled it
        can :send_message, User, receive_messages: true
        #can't send messages if receiver has not an email address
        cannot :send_message, User, email: nil
        #cannot send messages to himself
        cannot :send_message, User, id: user.id
      end


      can :index, [GroupParticipation, GroupArea], group: {participants: {id: user.id}}
      can :manage, [Quorum, BestQuorum, OldQuorum], group: {id: user.portavoce_group_ids}
      can :manage, GroupArea, group: {id: user.portavoce_group_ids, enable_areas: true}

      can [:create, :destroy], AreaParticipation, group_area: {group: {id: user.portavoce_group_ids}, area_participations: {user_id: :user_id}}

      #e sia l'amministratore o portavoce del gruppo
      #e che il ruolo appartenga al gruppo indicato o sia generico,
      #e l'utente a cui si modifica il ruolo appartenga al gruppo
      #e non si stia cambiando il ruolo dell'unico amministratore
      can :change_user_permission, GroupParticipation do |group_participation|
        puser = group_participation.user
        role = group_participation.participation_role
        group = group_participation.group
        (group.portavoce.include? user) && #check user is administrator
            (!role.group || (role.group == group)) && #check role is a group role
            (!(group.portavoce.include? puser) || (group.portavoce.count > 1)) #check user is not the only administrator

      end

      can :destroy, GroupParticipation do |group_participation|
        ((group_participation.participation_role_id != ParticipationRole::ADMINISTRATOR ||
            group_participation.group.portavoce.count > 1) &&
            user == group_participation.user) ||
            ((group_participation.group.portavoce.include? user) && (group_participation.user != user))
      end


      can :destroy, Authentication do |authentication|
        user == authentication.user && user.email #can destroy an identity provider only if the set a valid email address
      end

      can :read, BlogPost, reserved: true, groups: {group_participations: {user_id: user.id}}
      can :read, BlogPost, user_id: user.id

      can :update, BlogPost, user_id: user.id

      can :change_rotp_enabled, User if user.email

      can :read, Event, groups: {group_participations: {user_id: user.id}} #can also view private events of groups in which participates

      can :create, Event

      can [:update, :destroy], Event, user_id: user.id #can update my event
      can [:update, :destroy], Event, groups: {group_participations: {user_id: user.id, participation_role_id: ParticipationRole::ADMINISTRATOR}}
      can [:update, :destroy], Event, groups: {participation_roles: {action_abilitations: {group_action_id: GroupAction::CREATE_EVENT, group_id: 'groups.id'}}}
      cannot [:update, :destroy], Event, event_type_id: EventType::VOTAZIONE, proposals: ['proposals.id != null'], possible_proposals: ['proposals.id != null']

      can :read, Alert, user_id: user.id

      can :update, ProposalNickname, ["user_id = #{user.id} and created_at > :limit", limit: 10.minutes.ago] do |proposal_nickname|
        proposal_nickname.user_id == user.id &&
            proposal_nickname.created_at > 10.minutes.ago
      end

      can [:create, :like], EventComment, event: {groups: {group_participations: {user_id: user.id}}}
      can [:create, :like], EventComment, event: {private: false}

      can :destroy, EventComment, user_id: user.id

      can :create, MeetingParticipation, meeting: {event: {private: false}}
      can :create, MeetingParticipation, meeting: {event: {groups: {group_participations: {user_id: user.id}}}}
      cannot :create, MeetingParticipation, meeting: {event: ['endtime < :limit', limit: Time.now]}

      #forum permissions
      can :read, Frm::Category, group: {group_participations: {user_id: user.id}}
      can :read, Frm::Topic, group: {group_participations: {user_id: user.id}}
      can :read, Frm::Forum, group: {group_participations: {user_id: user.id}}

      can :create_topic, Frm::Forum, group: {group_participations: {user_id: user.id}}

      can :reply, Frm::Topic, group: {group_participations: {user_id: user.id}}

      can :edit_post, Frm::Forum, group: {group_participations: {user_id: user.id}}

      can :moderate, Frm::Forum do |forum|
        user.can_moderate_forem_forum?(forum) || user.forem_admin?(forum.group)
      end

      # Always performed
      can :access, :ckeditor # needed to access Ckeditor filebrowser

      # Performed checks for actions:
      can [:read, :create, :destroy], Ckeditor::Picture do |picture|
        picture.assetable_id == user.id
      end
      can [:read, :create, :destroy], Ckeditor::AttachmentFile do |attachment|
        picture.assetable_id == user.id
      end

      if user.moderator?
        can :read, Proposal # can see all the proposals
        can :destroy, ProposalComment do |proposal_comment|
          proposal_comment.grave_reports_count > 0
        end
        can :manage, Announcement

        #can edit participations to group areas
        can [:create, :destroy], AreaParticipation

        if user.admin?
          #can close debate of a proposal
          can :close_debate, Proposal, proposal_state_id: ProposalState::VALUTATION

          # can send messages to every user although they denied it
          can :send_message, User

          can :update, Proposal
          can :participate, Proposal
          can :set_votation_date, Proposal
          can :destroy, Proposal
          can :destroy, ProposalComment
          can :manage, Group
          can :manage, BlogPost
          can :manage, Quorum
          can [:read, :create, :update, :change_group_permission], ParticipationRole
          can :manage, Election
          can :manage, Event
          can :manage, Frm::Topic
          can :create_topic, Frm::Forum
          can :manage, Frm::Category
          can :manage, Frm::Forum
          can :manage, GroupArea
          can :index, GroupParticipation
        end
      end

    end
  end

  def can_do_on_group?(user, group, action)
    group.group_participations
    .joins(:participation_role => :action_abilitations)
    .where(["group_participations.user_id = :user_id and (participation_roles.id = #{ParticipationRole::ADMINISTRATOR} or action_abilitations.group_action_id = :action_id)", user_id: user.id, action_id: action]).uniq.exists?
  end
end