#encoding: utf-8
class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #user ||= User.new # guest user (not logged in)
    if !user
       can [:index,:show,:read], [Proposal, BlogPost, Blog, Group]
       #can :edit, Proposal, :user_id => user.id
    elsif user.admin?
       can :manage, :all
    else
      #TODO correggere quando più gruppi condivideranno le proposte
       can :read, Proposal do |proposal|
         !proposal.private || proposal.visible_outside || can_do_on_group?(user,proposal.presentation_groups.first,6)
       end
       can :partecipate, Proposal do |proposal|
         can_partecipate_proposal?(user,proposal)
       end
       can :vote, Proposal do |proposal|
         can_vote_proposal?(user,proposal)
       end
       can :new, ProposalSupport
       can :create, ProposalSupport do |support|
         user.groups.include? support.group
       end
       can :create, Group do |group|
         true
       end
       can :update, Group do |group|
         group.portavoce.include? user
       end
       can :update, PartecipationRole do |partecipation_role|
         partecipation_role.group.portavoce.include? user
       end
       can :update, AreaRole do |area_role|
         area_role.group_area.group.portavoce.include? user
       end
       can :update, GroupArea do |area|
         area.group.portavoce.include? user
       end

       can :post_to, Group do |group|
         can_do_on_group?(user,group,1)
       end
       can :create_event, Group do |group|
         can_do_on_group?(user,group,2)
       end
       can :support_proposal, Group do |group|
         can_do_on_group?(user,group,3)
       end
       can :accept_requests, Group do |group|
         can_do_on_group?(user,group,4) && ::Configuration.invites_active
       end
       can :create_election, Group do |group|
         #controllo se può creare eventi in generale
         can_do_on_group?(user,group,2)
       end
       can :send_candidate, Group do |group|
         #can_do_on_group?(user,group,4)
         can_do_on_group?(user,group,5)
       end
       can :view_proposal, Group do |group|
         #can_do_on_group?(user,group,4)
         can_do_on_group?(user,group,6)
       end
       can :partecipate_proposal, Group do |group|
         #can_do_on_group?(user,group,4)
         can_do_on_group?(user,group,7)
       end
       can :insert_proposal, Group do |group|
         #can_do_on_group?(user,group,4)
         can_do_on_group?(user,group,8)
       end
       can :view_proposal, GroupArea do |group_area|
         can_do_on_group_area?(user,group_area,6)
       end
       can :partecipate_proposal, GroupArea do |group_area|
         can_do_on_group_area?(user,group_area,7)
       end
       can :insert_proposal, GroupArea do |group_area|
         can_do_on_group_area?(user,group_area,8)
       end
       can :view_documents, Group do |group|
         can_do_on_group?(user,group,9)
       end
       can :manage_documents, Group do |group|
         can_do_on_group?(user,group,10)
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
         (group_partecipation.partecipation_role_id != PartecipationRole::PORTAVOCE ||
          group_partecipation.group.portavoce.count > 1) &&
          user == group_partecipation.user
       end

     end

      def can_do_on_group?(user,group,action)
       user.groups.where("partecipation_role_id = 2")
         partecipation = user.group_partecipations.first(:conditions => {:group_id => group.id})
         return false unless partecipation
         role = partecipation.partecipation_role
         return true if (role.id == PartecipationRole::PORTAVOCE)
         roles = group.partecipation_roles.all(:joins => :action_abilitations, :conditions => ["action_abilitations.group_action_id = ? AND action_abilitations.group_id = ?",action,group.id])
         return roles.include? role
      end


    def can_do_on_group_area?(user,group_area,action)
      group_partecipation = user.group_partecipations.first(:conditions => {:group_id => group_area.group.id})
      return false unless group_partecipation
      group_role = group_partecipation.partecipation_role
      return true if (group_role.id == PartecipationRole::PORTAVOCE)

      area_partecipation = user.area_partecipations.first(:conditions => {:group_area_id => group_area.id})
      return false unless area_partecipation
      role = area_partecipation.area_role
      roles = group_area.area_roles.all(:joins => :area_action_abilitations, :conditions => ["area_action_abilitations.group_action_id = ? AND area_action_abilitations.group_area_id = ?",action,group_area.id])
      return roles.include? role
    end

     #un utente può partecipare ad una proposta se è pubblica
     #oppure se dispone dei permessi necessari in uno dei gruppi all'interno dei quali la proposta
     #è stata creata
     def can_partecipate_proposal?(user,proposal)
       if proposal.private
         proposal.presentation_groups.each do |group|
            return true if can_do_on_group?(user,group,7) && (proposal.in_valutation? || proposal.voted?)
         end
         return false
       else
         return proposal.in_valutation? || proposal.voted?
       end
     end

    #un utente può votare una proposta se è pubblica
    #oppure se dispone dei permessi necessari in uno dei gruppi all'interno dei quali la proposta
    #è stata creata
    def can_vote_proposal?(user,proposal)
      if proposal.private
        proposal.presentation_groups.each do |group|
          return true if can_do_on_group?(user,group,7) && (proposal.voting?)
        end
        false
      else
        proposal.voting?
      end
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
