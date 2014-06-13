require 'sidekiq/web'

Airesis::Application.routes.draw do

  resources :searches

  resources :sys_payment_notifications

  resources :sys_features

  mount Ckeditor::Engine => '/ckeditor'

  get 'home' => 'home#show'
  get 'public' => 'home#public'
  get 'partecipa' => 'home#engage'
  get 'chisiamo' => 'home#whowe'
  get 'roadmap' => 'home#roadmap'
  get 'bugtracking' => 'home#bugtracking'
  get 'videoguide' => 'home#videoguide'
  get 'edemocracy' => 'home#whatis'
  get 'eparticipation' => 'home#intro'
  get 'story' => 'home#story'
  get 'sostienici' => 'home#helpus'
  get 'donations' => 'home#donations'
  get 'press' => 'home#press'
  get 'privacy' => 'home#privacy'
  get 'terms' => 'home#terms'
  get 'send_feedback' => 'home#feedback'
  get 'statistics' => 'home#statistics'
  get 'movements' => 'home#movements'
  get 'school' => 'home#school'
  get 'municipality' => 'home#municipality'

  resources :user_likes

  resources :proposal_nicknames

  #common routes both for main app and subdomains


  resources :quorums do
    collection do
      get :dates
      get :help
    end
  end

  resources :best_quorums, controller: 'quorums'
  resources :old_quorums, controller: 'quorums'

  resources :proposals do
    collection do
      get :endless_index
      get :similar
      get :tab_list
    end

    resources :proposal_comments do
      member do
        put :rankup
        put :ranknil
        put :rankdown
        get :show_all_replies
        put :unintegrate
        get :history
      end
      collection do
        post :mark_noise
        get :list
        get :left_list
        get :edit_list
        post :report
        get :noise
        get :manage_noise
      end
    end

    resources :proposal_histories
    resources :proposal_lives
    resources :proposal_supports
    resources :proposal_presentations

    resources :blocked_proposal_alerts do
      collection do
        post :block
        post :unlock
      end
    end

    member do
      get :rankup
      get :rankdown
      get :statistics
      patch :set_votation_date
      post :available_author
      get :available_authors_list
      put :add_authors
      get :vote_results
      post :close_debate
      patch :regenerate
      get :geocode
      get :facebook_share
      get :promote
      post :facebook_send_message
      get :banner
      get :test_banner
    end
  end

  resources :proposal_categories



  resources :announcements do
    member do
      post :hide
    end
  end

  resources :sys_movements

  resources :tutorial_progresses

  resources :tutorials do
    resources :steps do
      member do
        get :complete
      end
    end
    resources :tutorial_assignees
  end

  resources :alerts do
    member do
      get :check
      get :check_alert #todo remove in one year from 08-05-2014
    end

    collection do
      get :proposal
      post :check_all
    end
  end

  resources :group_invitations do
    collection do
      get :accept
      get :reject
      get :anymore
    end
  end

  resources :interest_borders
  resources :comunes

  get 'elfinder' => 'elfinder#elfinder'

  devise_for :users, controllers: {omniauth_callbacks: "users/omniauth_callbacks", sessions: "sessions", registrations: "registrations", passwords: "passwords", confirmations: 'confirmations'} do
    get '/users/sign_in', to: 'devise/sessions#new'
    get '/users/sign_out', to: 'devise/sessions#destroy'
    get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
  end


  resources :users do
    collection do
      get :confirm_credentials
      get :alarm_preferences #preferenze allarmi utente
      get :border_preferences #preferenze confini di interesse utente
      post :set_interest_borders #cambia i confini di interesse
      post :join_accounts
      get :privacy_preferences
      get :statistics
      post :change_show_tooltips
      post :change_show_urls
      post :change_receive_messages
      post :change_rotp_enabled
      post :change_locale
      post :change_time_zone
    end

    member do
      get :show_message
      post :send_message
      post :update_image
    end

    resources :authentications
  end

  resources :notifications do
    collection do
      post :change_notification_block
      post :change_email_notification_block
      post :change_email_block
    end
  end

  concern :blog_posts do
    resources :blog_posts do
      get :drafts, on: :collection
      resources :blog_comments
    end
  end

  concerns :blog_posts

  resources :blogs do
    concerns :blog_posts
    get '/:year/:month' => 'blogs#by_year_and_month', :as => :posts_by_year_and_month, on: :member
  end


  resources :tags

  get '/tags/:text', to: 'tags#show'

  get '/votation/', to: 'votations#show'
  put '/votation/vote', to: 'votations#vote'
  put '/votation/vote_schulze', to: 'votations#vote_schulze'
  resources :votations

  concern :eventable do
    resources :events do
      resources :meeting_participations, only: [:create]

      resources :event_comments do
        member do
          post :like
        end
      end
      member do
        post :move
        post :resize
      end
      collection do
        get :list
      end
    end
  end

  concern :participation_roles do
    resources :participation_roles do
      collection do
        post :change_default_role
      end
      member do
        post :change_group_permission
      end
    end
  end

  concerns :eventable

  #specific routes for subdomains
  constraints Subdomain do
    get '', to: 'groups#show'

    get '/edit', to: 'groups#edit'
    put '/update', to: 'groups#update'

    resources :elections
    resources :candidates

    resources :quorums do
      member do
        post :change_status
      end
    end


    resources :best_quorums, controller: 'quorums'
    resources :old_quorums, controller: 'quorums'

    resources :documents do
      get :view, on: :collection
    end

    resources :group_areas do
      resources :area_roles do
        member do
          patch :change
        end
        collection do
          patch :change_permissions
        end
      end
    end

    resources :group_participations do
      collection do
        post :send_email
        post :destroy_all
      end
      member do
        post :change_user_permission
      end
    end

    concerns :participation_roles

    resources :search_participants

    resources :forums, controller: 'frm/forums', only: [:index, :show] do
      resources :topics, controller: 'frm/topics' do
        member do
          get :subscribe
          get :unsubscribe
        end
      end


      resources :topics, controller: 'frm/topics', only: [:new, :create, :index, :show, :destroy] do
        resources :posts, controller: 'frm/posts'
      end


    end

    namespace :frm do
      get 'forums/:forum_id/moderation', to: "moderation#index", as: :forum_moderator_tools
      # For mass moderation of posts
      put 'forums/:forum_id/moderate/posts', to: "moderation#posts", as: :forum_moderate_posts
      # Moderation of a single topic
      put 'forums/:forum_id/topics/:topic_id/moderate', to: "moderation#topic", as: :moderate_forum_topic
      resources :categories, only: [:index, :show]
      namespace :admin do
        root to: "base#index"
        resources :groups, as: 'frm_groups' do
          resources :members do
            collection do
              post :add
            end
          end
        end

        resources :forums do
          resources :moderators
        end

        resources :categories
        resources :topics do
          member do
            put :toggle_hide
            put :toggle_lock
            put :toggle_pin
          end
        end
      end
    end

    get '/:action', controller: 'groups'
    put '/:action', controller: 'groups'
    post '/:action', controller: 'groups'

  end

  #routes available only on main site
  constraints NoSubdomain do

    root to: 'home#index'

    resources :certifications, only: [:index, :create, :destroy]
    resources :user_sensitives do
      member do
        get :document
      end
    end

    resources :proposal_categories do
      get :index, scope: :collection
    end

    resources :groups do
      member do
        get :ask_for_participation
        get :ask_for_follow
        put :participation_request_confirm
        put :participation_request_decline
        post :create_event
        post :change_default_anonima
        post :change_default_visible_outside
        post :change_advanced_options
        post :change_default_secret_vote
        get :reload_storage_size
        put :enable_areas
        put :remove_post
        put :feature_post
        get :permissions_list
      end

      collection do
        post :ask_for_multiple_follow
        get :autocomplete
      end


      resources :forums, controller: 'frm/forums', only: [:index, :show] do
        resources :topics, controller: 'frm/topics' do
          member do
            get :subscribe
            get :unsubscribe
          end
        end


        resources :topics, controller: 'frm/topics', only: [:new, :create, :index, :show, :destroy] do
          resources :posts, controller: 'frm/posts'
        end


      end

      namespace :frm do
        get 'forums/:forum_id/moderation', to: "moderation#index", as: :forum_moderator_tools
        # For mass moderation of posts
        put 'forums/:forum_id/moderate/posts', to: "moderation#posts", as: :forum_moderate_posts
        # Moderation of a single topic
        put 'forums/:forum_id/topics/:topic_id/moderate', to: "moderation#topic", as: :moderate_forum_topic
        resources :categories, only: [:index, :show]
        namespace :admin do
          root to: "base#index"
          resources :groups, as: 'frm_groups' do
            resources :members do
              collection do
                post :add
              end
            end
          end

          resources :forums do
            resources :moderators
          end

          resources :categories
          resources :topics do
            member do
              put :toggle_hide
              put :toggle_lock
              put :toggle_pin
            end
          end
        end
      end

      get 'users/autocomplete', to: "users#autocomplete", as: "user_autocomplete"

      concerns :eventable

      resources :elections

      resources :candidates

      resources :group_participations do
        collection do
          post :send_email
          post :destroy_all
        end
        member do
          post :change_user_permission
        end
      end

      concerns :participation_roles

      resources :search_participants

      resources :proposals do
        collection do
          get :search
        end
        member do
          post :close_debate
          patch :regenerate
          get :geocode
        end
      end

      resources :quorums do
        member do
          post :change_status
        end
      end


      resources :best_quorums, controller: 'quorums'
      resources :old_quorums, controller: 'quorums'

      resources :documents do
        collection do
          get :view
        end
      end

      resources :group_areas do
        resources :area_roles do
          member do
            patch :change
          end
          collection do
            put :change_permissions
          end
        end

        resources :area_participations, only: [:create, :update, :destroy]
      end

      concerns :blog_posts

      get '/:year/:month' => 'groups#by_year_and_month', :as => :posts_by_year_and_month, on: :member
    end

    resources :documents do
      collection do
        get :view
        get :download
      end
      member do
      end
    end

    resources :elections do
      member do
        get :vote_page
        post :vote
        get :calculate_results
      end
    end

    match ':controller/:action/:id', via: :all

    match ':controller/:action/:id.:format', via: :all


    admin_required = lambda do |request|
      request.env['warden'].authenticate? and request.env['warden'].user.admin?
    end

    moderator_required = lambda do |request|
      request.env['warden'].authenticate? and request.env['warden'].user.moderator?
    end

    constraints moderator_required do
      match ':controller/:action/', via: :all
      get 'moderator_panel', to: 'moderator#show', as: 'moderator/panel'
    end


    constraints admin_required do
      mount Sidekiq::Web => "/sidekiq"
      mount Maktoub::Engine => "/maktoub/"
      match ':controller/:action/', via: :all
      resources :admin
      get 'admin_panel', to: 'admin#show', as: 'admin/panel'
    end


    resources :tokens, only: [:create, :destroy]

    get '/:id' => 'groups#show'

  end

end
