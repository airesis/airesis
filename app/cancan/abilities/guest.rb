module Abilities
  class Guest
    include CanCan::Ability

    def initialize(_user)
      can :read, Event, private: false

      visible_groups_stuff
      visible_forum_stuff
      visible_blogs_stuff
      visible_proposals_stuff

      can :show, User
      can :read, Announcement, ['starts_at <= :now and ends_at >= :now', now: Time.zone.now] do
        true
      end
      can :hide, Announcement
    end

    def visible_proposals_stuff
      can [:read, :new, :report, :history, :list, :left_list, :show_all_replies],
          ProposalComment,
          proposal: { private: false }
      can [:list, :left_list, :index], ProposalComment
      can :read, Proposal, private: false
      can :read, Proposal, visible_outside: true
    end

    def visible_groups_stuff
      can [:index, :show, :read], [Blog, Group, GroupArea]
      can [:view_data, :by_year_and_month], Group, private: false
      can :ask_for_participation, Group
      can :ask_for_multiple_follow, Group
      can :read, GroupInvitation
      can [:accept, :reject, :anymore, :show], GroupInvitationEmail
    end

    def visible_blogs_stuff
      r_blog_post_is_public = { status: BlogPost::PUBLISHED }
      can :read, BlogPost, r_blog_post_is_public
      can :read, PostPublishing, blog_post: r_blog_post_is_public
      can :new, BlogComment, blog_post: r_blog_post_is_public
      can [:read, :new], BlogComment, blog: r_blog_post_is_public
    end

    def visible_forum_stuff
      r_category_is_public = { visible_outside: true }
      can :read, Frm::Category, r_category_is_public
      can :read, Frm::Forum, visible_outside: true, category: r_category_is_public
      can :read, Frm::Topic, forum: { visible_outside: true, category: r_category_is_public }
    end
  end
end
