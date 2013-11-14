#encoding: utf-8
class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #user ||= User.new # guest user (not logged in)
    if !user
      can [:index, :show, :read], [Proposal, BlogPost, Blog, Group]
      can :view_data, Group do |group|
        !group.is_private?
      end

      #forum permissions
      can :read, Frm::Category do |category|
        category.visible_outside
      end


      can :read, Frm::Topic do |topic|
        topic.forum.visible_outside && topic.forum.category.visible_outside
      end


      can :read, Frm::Forum do |forum|
        forum.visible_outside && forum.category.visible_outside
      end

    else
      #TODO correggere quando più gruppi condivideranno le proposte
      can :read, Proposal do |proposal|
        can_read_proposal?(user, proposal)
      end
      can :update, Proposal do |proposal|
        can_edit_proposal?(user, proposal)
      end
      can :partecipate, Proposal do |proposal|
        can_partecipate_proposal?(user, proposal)
      end
      can :vote, Proposal do |proposal|
        can_vote_proposal?(user, proposal)
      end
      #can :choose_date, Proposal do |proposal|
      #  if proposal.private?
      #    group = proposal.presentation_groups.first
      #    (can? :choose_proposal_date, group) && (user.is_mine? proposal)
      #  else
      #    user.is_mine? proposal
      #  end
      #end
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

      can :update, Group do |group|
        group.portavoce.include? user
      end
      can :destroy, Group do |group|
        (group.portavoce.include? user) && (group.partecipants.count < 2)
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
        can_do_on_group?(user, group, 4)
      end
      can :create_election, Group do |group|
        #controllo se può creare eventi in generale
        can_do_on_group?(user, group, 2)
      end
      can :send_candidate, Group do |group|
        #can_do_on_group?(user,group,4)
        can_do_on_group?(user, group, 5)
      end
      can :view_proposal, Group do |group|
        #can_do_on_group?(user,group,4)
        can_do_on_group?(user, group, 6)
      end
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
        !group.is_private? || (group.partecipants.include? user) #todo remove first condition
      end

      can :update, PartecipationRole do |partecipation_role|
        partecipation_role.group.portavoce.include? user
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
        (area.group.portavoce.include? user) && (area.internal_proposals.count == 0)
      end

      can :read, Election do |election|
        group = election.groups.first
        group.partecipants.include? user #posso visualizzare un'elezione solo se appartengo al gruppo
      end
      can :vote, Election do |election|
        group = election.groups.first
        group.partecipants.include? user #posso visualizzare un'elezione solo se appartengo al gruppo
      end

      #should be you, and proposal must have more users
      can :destroy, ProposalPresentation do |presentation|
        presentation.user == user &&
        presentation.proposal.users.count > 1
      end

      #can :update, Proposal do |proposal|
      #  proposal.users.include? user
      #end
      can :destroy, ProposalComment do |comment|
        (comment.user == user or comment.proposal.users.include? user) and ((Time.now - comment.created_at)/60) < 5
      end
      can :show_tooltips, User do |fake|
        user.show_tooltips
      end
      can :send_message, User do |ut|
        ut.receive_messages && user != ut && ut.email && user.email
      end

      can :destroy, GroupPartecipation do |group_partecipation|
        ((group_partecipation.partecipation_role_id != PartecipationRole::PORTAVOCE ||
            group_partecipation.group.portavoce.count > 1) &&
            user == group_partecipation.user) ||
            ((group_partecipation.group.portavoce.include? user) && (group_partecipation.user != user))
      end

      can :destroy, Authentication do |authentication|
        user == authentication.user && user.email #can destroy an identity provider only if the set a valid email address
      end

      can :update, BlogPost do |blog_post|
        blog_post.user == user
      end

      can :change_rotp_enabled, User if user.email


      can :update, Event do |event|
        can_edit_event?(user, event)
      end
      can :destroy, Event do |event|
        can_edit_event?(user, event)
      end

      can :update, ProposalNickname do |proposal_nickname|
        proposal_nickname.created_at > Time.now - 10.minutes &&
            proposal_nickname.user == user
      end


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
      can :access, :ckeditor   # needed to access Ckeditor filebrowser

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
      end

      if user.admin?
        can :close_debate, Proposal do |proposal| #can close debate of a proposal
          proposal.in_valutation?
        end
        can :send_message, User # can send messages to every user although they denied it

        can :update, Proposal #can edit them
        can :partecipate, Proposal #can partecipate
        #can :choose_date, Proposal #can edit them
        can :destroy, Proposal #can destroy one
        can :destroy, ProposalComment
        can :manage, Group
        can :manage, BlogPost
        can :manage, Quorum
        can :update, PartecipationRole
        can :manage, Election
        can :manage, Event
        can :manage, Frm::Topic
        can :create_topic, Frm::Forum

        #cannot :show_tooltips
        #can :vote, Proposal do |proposal|
        #  can_vote_proposal?(user, proposal)
        #end
        #can :destroy, ProposalComment do |comment|
        #  (user.is_mine? comment) && (((Time.now - comment.created_at)/60) < 5)
        #end
      end

    end

    #you can edit an event only if you have permissions or you are an admin
    #if it's votation there must not be any proposal attached
    #if it's election should be no candidate yet
    def can_edit_event?(user, event)
      group = event.organizers.first
      #can edit the event only if has permissions in the group
      c1 = false
      if group
        c1 = (group.scoped_partecipants(GroupAction::CREATE_EVENT).include? user)
      else
        c1 = user.admin?
      end
      #can edit the event only if the user created it or if it's the admin of the group
      c2 = event.user ?  ((user == event.user) || (group.portavoce.include? user)) : true
      c1 && c2 &&
      ((event.is_votazione? && event.proposals.count == 0 && event.possible_proposals.count == 0) ||
       (event.is_incontro? || event.is_riunione?))
    end


    def can_do_on_group?(user, group, action)
      user.groups.where("partecipation_role_id = 2")
      partecipation = user.group_partecipations.first(:conditions => {:group_id => group.id})
      return false unless partecipation
      role = partecipation.partecipation_role
      return true if (role.id == PartecipationRole::PORTAVOCE)
      roles = group.partecipation_roles.all(:joins => :action_abilitations, :conditions => ["action_abilitations.group_action_id = ? AND action_abilitations.group_id = ?", action, group.id])
      roles.include? role
    end


    def can_do_on_group_area?(user, group_area, action)
      group_partecipation = user.group_partecipations.first(:conditions => {:group_id => group_area.group.id})
      return false unless group_partecipation
      group_role = group_partecipation.partecipation_role
      return true if (group_role.id == PartecipationRole::PORTAVOCE)

      area_partecipation = user.area_partecipations.first(:conditions => {:group_area_id => group_area.id})
      return false unless area_partecipation
      role = area_partecipation.area_role
      roles = group_area.area_roles.all(:joins => :area_action_abilitations, :conditions => ["area_action_abilitations.group_action_id = ? AND area_action_abilitations.group_area_id = ?", action, group_area.id])
      roles.include? role
    end


    def can_read_proposal?(user, proposal)
      if proposal.private
        return true if proposal.visible_outside
        if proposal.presentation_areas.count > 0 #if it's inside a specific area
          return can_do_on_group_area?(user, proposal.presentation_areas.first, GroupAction::PROPOSAL_VIEW)
        else
          return can_do_on_group?(user, proposal.presentation_groups.first, GroupAction::PROPOSAL_VIEW) #todo when a proposal will be presented by more groups
        end
      else
        true
      end

    end

    #un utente può modificare una proposta se ne è l'autore e
    #se è standard solo durante la fase di dibattito
    #se è un sondaggio prima che venga messa in votazione
    def can_edit_proposal?(user, proposal)
      return false unless user.is_mine? proposal
      if proposal.is_polling?
        [ProposalState::WAIT_DATE.to_s, ProposalState::WAIT.to_s].include? proposal.proposal_state_id.to_s
      else
        proposal.proposal_state_id.to_s == ProposalState::VALUTATION.to_s
      end
    end

    #un utente può partecipare ad una proposta se è pubblica
    #oppure se dispone dei permessi necessari in uno dei gruppi all'interno dei quali la proposta
    #è stata creata
    def can_partecipate_proposal?(user, proposal)
      if proposal.private
        proposal.presentation_groups.each do |group|
          areas = proposal.presentation_areas.where(:group_id => group.id)
          if areas.count > 0
            if can_do_on_group_area?(user, areas.first, GroupAction::PROPOSAL_PARTECIPATION)
              if proposal.is_polling? && (proposal.voting? || proposal.voted?)
                return true
              elsif proposal.in_valutation? || proposal.voted?
                return true
              end
            end
          else
            if can_do_on_group?(user, group, GroupAction::PROPOSAL_PARTECIPATION)
              if proposal.is_polling? && (proposal.voting? || proposal.voted?)
                return true
              elsif proposal.in_valutation? || proposal.voted?
                return true
              end
            end
          end

        end
        return false
      else
        if  proposal.is_polling? && (proposal.voting? || proposal.voted?)
          return true
        elsif proposal.in_valutation? || proposal.voted?
          return true
        else
          return false
        end
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
          areas = proposal.presentation_areas.where(:group_id => group.id)
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
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
