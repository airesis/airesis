module Abilities
  class Blogs
    include CanCan::Ability
    include Abilities::Commons

    def initialize(user)
      blogs_permissions(user)
    end

    def blogs_permissions(user)
      r_blog_post_is_public = { status: BlogPost::PUBLISHED }

      can [:edit, :update, :destroy], Blog, user_id: user.id
      can [:new, :create], Blog unless user.blog

      can :read, BlogPost, status: BlogPost::RESERVED, groups: participate_in_group(user)
      can :read, PostPublishing, blog_post: { status: BlogPost::RESERVED, groups: participate_in_group(user) }

      can :drafts, BlogPost, status: BlogPost::DRAFT, user_id: user.id
      can :read, BlogPost, user_id: user.id
      can :read, PostPublishing, blog_post: { user_id: user.id }

      can [:edit, :update, :destroy], BlogPost, user_id: user.id
      if user.blog
        can :create, BlogPost, blog: { user_id: user.id }
        can :create, BlogPost, publishings: { group: participate_in_group(user) }
      end

      can :create, BlogComment, blog_post: r_blog_post_is_public
      can :create, BlogComment, blog_post: { user_id: user.id }
      can :create, BlogComment, blog_post: { groups: participate_in_group(user) }

      can :destroy, BlogComment, user_id: user.id
      can :destroy, BlogComment, blog_post: { user_id: user.id }
    end
  end
end
