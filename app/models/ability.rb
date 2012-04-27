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
       can :read, Proposal
       can :new, ProposalSupport
       can :create, ProposalSupport do |support|
         user.groups.include? support.group
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
         can_do_on_group?(user,group,4)         
       end
       #can :update, Proposal do |proposal|
       #  proposal.users.include? user
       #end
       
       
     end          
     
      def can_do_on_group?(user,group,action)
       user.groups.where("partecipation_role_id = 2")
         partecipation = user.group_partecipations.find(:first, :conditions => {:group_id => group.id})
         return false unless partecipation
         role = partecipation.partecipation_role
         return true if (role.id == PartecipationRole::PORTAVOCE)
         return false if (role.id == PartecipationRole::MEMBER)
         roles = group.partecipation_roles.find(:all, :joins => :action_abilitations, :conditions => "action_abilitations.group_action_id = #{action} AND action_abilitations.group_id = #{group.id}")
         return roles.include? role
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
