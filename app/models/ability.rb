#encoding: utf-8
class Ability
  include CanCan::Ability

  def initialize(user)
    can [:index, :show, :read], [BlogPost, Blog, Group]
    can :view_data, Group, private: false
    can :read, Frm::Category, visible_outside: true
    can :read, Frm::Topic, forum: {visible_outside: true}, forum: {category: {visible_outside: true}}
    can :read, Frm::Forum, visible_outside: true, category: {visible_outside: true}
    can :read, Event, private: false

    can :index, Proposal
    can :show, Proposal, private: false
    can :show, Proposal, visible_outside: true
    can :read, Announcement, ["starts_at <= :now and ends_at >= :now", now: Time.zone.now] do |a|
      true
    end
    if user
      can :create, Proposal, group: {group_participations: {user_id: user.id, participation_role_id: ParticipationRole::ADMINISTRATOR}}

      #can see proposals in group in which is administrator
      can :show, Proposal, presentation_groups: {group_participations: {user_id: user.id, participation_role_id: ParticipationRole::ADMINISTRATOR}}

      #can see proposals in groups in which has permission, not belonging to any area
      can :show, Proposal, presentation_groups: {group_participations: {user_id: user.id, participation_role: {action_abilitations: {group_action_id: GroupAction::PROPOSAL_VIEW}}}}
      #but can't see all proposals in presentation area
      cannot :show, Proposal, :presentation_areas

      #can see proposals in group areas in which has permission
      can :show, Proposal, presentation_areas: {area_participations: {user_id: user.id, area_role: {area_action_abilitations: {group_action_id: GroupAction::PROPOSAL_VIEW}}}}

      can [:edit,:update], Proposal, users: {id: user.id}, proposal_state_id: ProposalState::VALUTATION

      can :partecipate, Proposal do |proposal|
        can_partecipate_proposal?(user, proposal)
      end
      can :vote, Proposal do |proposal|
        can_vote_proposal?(user, proposal)
      end
      can :set_votation_date, Proposal, proposal_state_id: ProposalState::WAIT_DATE, users: {id: user.id}
      can :set_votation_date, Proposal do |proposal| #return true if the user can put the proposal in votation
        (user.is_mine? proposal) ||
            ((proposal.updated_at < (Time.now - 5.days)) && proposal.private? && (can_do_on_group?(user, proposal.presentation_groups.first, GroupAction::PROPOSAL_DATE)))
      end
      can :regenerate, Proposal do |proposal|
        can_regenerate_proposal?(user, proposal)
      end
      can :destroy, Proposal do |proposal|
        (proposal.users.include? user) &&
            !(((Time.now - proposal.created_at) > 10.minutes) && (proposal.valutations > 0 || proposal.contributes.count > 0)) &&
            proposal.in_valutation?
      end


      can :destroy, ProposalComment do |comment| #you can destroy a contribute only if it's yours and it has been posted less than 5 minutes ago
        (user.is_mine? comment) && (((Time.now - comment.created_at)/60) < 5)
      end
      can :unintegrate, ProposalComment do |comment|
        (user.is_mine? comment) && comment.integrated
      end
      can :close_debate, Proposal do |proposal|
        can_close_debate_proposal?(user, proposal)
      end
      can :new, ProposalSupport
      can :create, ProposalSupport do |support|
        user.groups.include? support.group
      end
      can :create, Group if LIMIT_GROUPS && ((Time.now - (user.portavoce_groups.maximum(:created_at) || (Time.now - (GROUPS_TIME_LIMIT + 1.seconds))) > GROUPS_TIME_LIMIT)) #puoi creare solo un gruppo ogni 24 ore

      can :read, Group
      can :update, Group do |group|
        group.portavoce.include? user
      end
      can :destroy, Group do |group|
        (group.portavoce.include? user) && (group.participants.count < 2)
      end
      can :remove_post, Group do |group|
        group.portavoce.include? user
      end

      can :view_documents, Group do |group|
        can_do_on_group?(user, group, 9)
      end
      can :manage_documents, Group do |group|
        can_do_on_group?(user, group, 10)
      end

      can :post_to, Group do |group|
        can_do_on_group?(user, group, 1)
      end
      can :create_event, Group do |group|
        can_do_on_group?(user, group, GroupAction::CREATE_EVENT)
      end
      can :support_proposal, Group do |group|
        can_do_on_group?(user, group, 3)
      end
      can :accept_requests, Group do |group|
        can_do_on_group?(user, group, 4) && !group.disable_participation_requests
      end
      can :create_election, Group do |group|
        #controllo se può creare eventi in generale
        can_do_on_group?(user, group, 2)
      end
      can :send_candidate, Group do |group|
        #can_do_on_group?(user,group,4)
        can_do_on_group?(user, group, 5)
      end

      can :view_proposal, Group, group_participations: {user_id: user.id, participation_role_id: ParticipationRole::ADMINISTRATOR}
      can :view_proposal, Group, group_participations: {user_id: user.id, participation_role: {action_abilitations: {group_action_id: GroupAction::PROPOSAL_VIEW}}}

      can :insert_proposal, Group do |group|
        #can_do_on_group?(user,group,4)
        can_do_on_group?(user, group, 8)
      end
      can :create_date, Group do |group|
        #can_do_on_group?(user,group,4)
        can_do_on_group?(user, group, GroupAction::PROPOSAL_DATE)
      end
      can :create_both_events, Group do |group|
        can_do_on_group?(user, group, GroupAction::PROPOSAL_DATE) && can_do_on_group?(user, group, GroupAction::CREATE_EVENT)

      end
      can :create_any_event, Group do |group|
        can_do_on_group?(user, group, GroupAction::PROPOSAL_DATE) || can_do_on_group?(user, group, GroupAction::CREATE_EVENT)
      end
      can :view_data, Group do |group|
        !group.is_private? || (group.participants.include? user) #todo remove first condition
      end


      can [:read, :create, :update, :change_group_permission], ParticipationRole, group_id: user.portavoce_group_ids

      can :destroy, ParticipationRole do |participation_role|
        participation_role.id != participation_role.group.participation_role_id
      end

      can :update, AreaRole do |area_role|
        area_role.group_area.group.portavoce.include? user
      end
      can :view_proposal, GroupArea do |group_area|
        can_do_on_group_area?(user, group_area, 6)
      end
      can :insert_proposal, GroupArea do |group_area|
        can_do_on_group_area?(user, group_area, 8)
      end
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


      can :update, ProposalComment do |comment|
        comment.user == user
      end
      can :destroy, ProposalComment do |comment|
        (comment.user == user) and ((Time.now - comment.created_at)/60) < 5
      end
      can :rank, ProposalComment do |comment|
        can_partecipate_proposal?(user, comment.proposal)
      end

      can :show_tooltips, User, show_tooltips: true

      can :send_message, User do |ut|
        ut.receive_messages && user != ut && ut.email && user.email
      end

      can :index, [GroupParticipation,GroupArea], group: {participants: {id: user.id}}
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

      can :read, BlogPost do |blog_post|
        blog_post.published? ||
            blog_post.user == user ||
            (blog_post.reserved? && can_view_post?(user, blog_post))

      end

      can :update, BlogPost, user_id: user.id

      can :change_rotp_enabled, User if user.email

      can :read, Event, groups: {group_participations: {user_id: user.id}} #can also view private events of groups in which partecipate

      can :create, Event

      can [:update, :destroy], Event, user_id: user.id #can update my event
      can [:update, :destroy], Event, groups: {group_participations: {user_id: user.id, participation_role_id: ParticipationRole::ADMINISTRATOR}}
      can [:update, :destroy], Event, groups: {participation_roles: {action_abilitations: {group_action_id: GroupAction::CREATE_EVENT, group_id: 'groups.id'}}}
      cannot [:update, :destroy], Event, event_type_id: EventType::VOTAZIONE, proposals: ['proposals.id != null'], possible_proposals: ['proposals.id != null']


      can :read, Alert, user_id: user.id


      can :update, ProposalNickname do |proposal_nickname|
        proposal_nickname.created_at > Time.now - 10.minutes &&
            proposal_nickname.user == user
      end

      can [:create, :like], EventComment, event: {groups: {group_participations: {user_id: user.id}}}
      can [:create, :like], EventComment, event: {private: false}

      can :destroy, EventComment, user_id: user.id

      can :create, MeetingParticipation, meeting: {event: {private: false}}
      can :create, MeetingParticipation, meeting: {event: {groups: {group_participations: {user_id: user.id}}}}
      cannot :create, MeetingParticipation, meeting: {event: ['endtime < ?', Time.now]}

      #forum permissions
      can :read, Frm::Category do |category|
        user.can_read_forem_category?(category)
      end

      can :read, Frm::Topic do |topic|
        user.can_read_forem_forum?(topic.forum) && user.can_read_forem_topic?(topic)
      end

      can :read, Frm::Forum do |forum|
        user.can_read_forem_category?(forum.category) && user.can_read_forem_forum?(forum)
      end


      can :create_topic, Frm::Forum do |forum|
        can?(:read, forum) && user.can_create_forem_topics?(forum)
      end

      can :reply, Frm::Topic do |topic|
        can?(:read, topic.forum) && user.can_reply_to_forem_topic?(topic)
      end

      can :edit_post, Frm::Forum do |forum|
        user.can_edit_forem_posts?(forum)
      end

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
        can :destroy, ProposalComment do |comment|
          comment.grave_reports_count > 0
        end
        can :manage, Announcement
        #can edit participations to group areas
        can [:create, :destroy], AreaParticipation


        if user.admin?
          can :close_debate, Proposal do |proposal| #can close debate of a proposal
            proposal.in_valutation?
          end
          can :send_message, User # can send messages to every user although they denied it

          can :update, Proposal #can edit them
          can :partecipate, Proposal #can partecipate
          can :set_votation_date, Proposal
          can :destroy, Proposal #can destroy one
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

    #you can edit an event only if you have permissions or you are an admin
    #if it's votation there must not be any proposal attached
    #if it's election should be no candidate yet
    def can_edit_event?(user, event)
      group = event.groups.first
      #can edit the event only if has permissions in the group
      c1 = false
      if group
        c1 = (group.scoped_participants(GroupAction::CREATE_EVENT).include? user)
      else
        c1 = user.admin?
      end
      #can edit the event only if the user created it or if it's the admin of the group
      c2 = event.user ? ((user == event.user) || (group && (group.portavoce.include? user))) : true
      c1 && c2 &&
          ((event.is_votazione? && event.proposals.count == 0 && event.possible_proposals.count == 0) ||
              (event.is_incontro? || event.is_riunione?))
    end


    def can_do_on_group?(user, group, action)
      group.group_participations
      .joins(:participation_role => :action_abilitations)
      .where(["group_participations.user_id = :user_id and (participation_roles.id = #{ParticipationRole::ADMINISTRATOR} or action_abilitations.group_action_id = :action_id)", user_id: user.id, action_id: action]).uniq.exists?
    end

    def can_do_on_group_area?(user, group_area, action)
      group_area.area_participations
      .joins(:area_role => :area_action_abilitations)
      .where(["area_participations.user_id = :user_id and area_action_abilitations.id = :action_id",user_id: user.id, action_id: action]).uniq.exists?
    end

    #un utente può partecipare ad una proposta se è pubblica
    #oppure se dispone dei permessi necessari in uno dei gruppi all'interno dei quali la proposta
    #è stata creata
    def can_partecipate_proposal?(user, proposal)
      if proposal.private
        proposal.presentation_groups.each do |group|
          areas = proposal.presentation_areas.where(group_id: group.id)
          if areas.count > 0
            if can_do_on_group_area?(user, areas.first, GroupAction::PROPOSAL_PARTICIPATION)
              if proposal.is_polling? && (proposal.voting? || proposal.voted?)
                return true
              elsif proposal.in_valutation? || proposal.voted?
                return true
              end
            end
          else
            if can_do_on_group?(user, group, GroupAction::PROPOSAL_PARTICIPATION)
              return proposal.in_valutation? || proposal.voted?
            end
          end

        end
        false
      else
        proposal.in_valutation? || proposal.voted?
      end
    end

    #on some systems the group admin can close the debate
    def can_close_debate_proposal?(user, proposal)
      #if proposal.private && proposal.in_valutation?
      #  proposal.presentation_groups.each do |group|
      #    return true if group.portavoce.include? user
      #  end
      #end
      false
    end

    #un utente può votare una proposta se è pubblica
    #oppure se dispone dei permessi necessari in uno dei gruppi all'interno dei quali la proposta
    #è stata creata e se non ha già votato la proposta
    #e se la proposta è in votazione
    def can_vote_proposal?(user, proposal)
      return false unless proposal.voting?
      return false if UserVote.find_by_proposal_id_and_user_id(proposal.id, user.id)
      if proposal.private
        proposal.presentation_groups.each do |group|
          areas = proposal.presentation_areas.where(group_id: group.id)
          return can_do_on_group_area?(user, areas.first, GroupAction::PROPOSAL_VOTE) if areas.count > 0
          return true if can_do_on_group?(user, group, GroupAction::PROPOSAL_VOTE)
          return false
        end
      end
      true
    end

    def can_regenerate_proposal?(user, proposal)
      return false unless proposal.abandoned?
      proposal.private ?
          can_do_on_group?(user, proposal.presentation_groups.first, GroupAction::PROPOSAL_INSERT) :
          true
    end

    def can_view_post?(user, blog_post)
      blog_post.groups.joins(:group_participations).where('group_participations.user_id = ?', user.id).exists?
    end
  end
end
