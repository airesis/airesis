Airesis::Application.routes.draw do

  match 'home', :to => 'home#show'

  resources :proposal_nicknames

  #common routes both for main app and subdomains
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
        post :show_all_replies
        put :unintegrate
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
      put :set_votation_date
      post :available_author
      get :available_authors_list
      put :add_authors
      get :vote_results
      post :close_debate
      put :regenerate
    end
  end

  resources :proposal_categories

  resources :blogs do
    resources :blog_posts do
      #match :tag, :on => :member
      match :drafts, :on => :collection
      resources :blog_comments
    end
  end

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
      get :check_alert
    end

    collection do
      get :polling
      get :read_alerts
      post :check_all
    end
  end

  resources :interest_borders
  resources :comunes

  match 'elfinder' => 'elfinder#elfinder'

  devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks", :registrations => "registrations", :passwords => "passwords", :confirmations => 'confirmations'} do
    get '/users/sign_in', :to => 'devise/sessions#new'
    get '/users/sign_out', :to => 'devise/sessions#destroy'
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
      post :change_show_tooltips
      post :change_show_urls
      post :change_receive_messages
      post :change_rotp_enabled
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

  resources :partecipation_roles do
    collection do
      post :change_group_permission
      post :change_user_permission
      post :change_default_role
    end
  end

  resources :blog_posts

  match '/tags/:text', :to => 'tags#show', :as => 'tag'

  match '/votation/', :to => 'votations#show'
  match '/votation/vote', :to => 'votations#vote'
  match '/votation/vote_schulze', :to => 'votations#vote_schulze'
  resources :votations

  #specific routes for subdomains
  constraints Subdomain do
    match '', to: 'groups#show'

    match '/edit', to: 'groups#edit'
    match '/update', to: 'groups#update'


    resources :candidates

    resources :documents do
      collection do
        get :view
      end
    end


    resources :events do
      resources :meeting_partecipations
      member do
        post :move
        post :resize
      end
      collection do
        get :list
      end
    end


    resources :group_areas do
      collection do
        put :change
        get :manage
      end

      resources :area_roles do
        collection do
          put :change
          put :change_permissions
        end
      end
    end

    resources :group_partecipations do
      collection do
        post :send_email
      end
    end


    get '/:action', controller: 'groups'

  end

  #routes available only on main site
  constraints NoSubdomain do

    root :to => 'home#index'

    #match ':controller/:action/:id'

    resources :proposal_categories do
      get :index, scope: :collection
    end



    resources :events do
      resources :meeting_partecipations
      member do
        post :move
        post :resize
      end
      collection do
        get :list
      end
    end

    resources :group_invitations do
      collection do
        get :accept
        get :reject
        get :anymore
      end
    end


    resources :groups do
      member do
        get :ask_for_partecipation
        get :ask_for_follow
        get :partecipation_request_confirm
        get :edit_events
        get :new_event
        post :create_event
        get :edit_permissions
        get :edit_proposals
        post :change_default_anonima
        post :change_default_visible_outside
        post :change_advanced_options
        post :change_default_secret_vote
        get :reload_storage_size
        put :enable_areas
        put :remove_post
        get :permissions_list
      end

      collection do
        post :ask_for_multiple_follow
      end

      resources :events do
        resources :meeting_partecipations
        member do
          post :move
          post :resize
        end
        collection do
          get :list
        end
      end

      resources :elections

      resources :candidates

      resources :group_partecipations do
        collection do
          post :send_email
        end
      end

      resources :search_partecipants

      resources :proposals do
        collection do
          get :search
        end
        member do
          post :close_debate
          put :regenerate
        end
      end

      resources :quorums do
        member do
          post :change_status
        end
      end

      resources :documents do
        collection do
          get :view
        end
      end

      resources :group_areas do
        collection do
          put :change
          get :manage
        end

        resources :area_roles do
          collection do
            put :change
            put :change_permissions
          end
        end
      end

      resources :blog_posts do
        #match :tag, :on => :member
        match :drafts, :on => :collection
        resources :blog_comments
      end
    end

    resources :documents do
      collection do
        get :view
        get :download
      end
      member do
      end
    end

    resources :quorums do
      collection do
        get :help
      end
    end

    resources :elections do
      member do
        get :vote_page
        post :vote
        get :calculate_results
      end
    end



    match ':controller/:action/:id'

    match ':controller/:action/:id.:format'

    match 'index_by_category', :to => 'proposals#index_by_category', :as => '/proposals/index_by_category'


    #url friendly 'proposte'
    #match ':proposal_url/:id', :to => 'proposals#show'
    #match ':proposal_url', :to => 'proposals#index'
    #match ':proposal_url/cat/:category/', :to => 'proposals#index'

    match '/partecipa' => 'home#engage'
    match '/chisiamo' => 'home#whowe'
    match '/roadmap' => 'home#roadmap'
    match '/bugtracking' => 'home#bugtracking'
    match '/videoguide' => 'home#videoguide'
    match '/edemocracy' => 'home#whatis'
    match '/sostienici' => 'home#helpus'
    match '/press' => 'home#press'
    match '/privacy' => 'home#privacy'
    match '/terms' => 'home#terms'
    match '/send_feedback' => 'home#feedback'
    match '/statistics' => 'home#statistics'
    match '/movements' => 'home#movements'

    admin_required = lambda do |request|
      request.env['warden'].authenticate? and request.env['warden'].user.admin?
    end

    moderator_required = lambda do |request|
      request.env['warden'].authenticate? and request.env['warden'].user.moderator?
    end

    constraints moderator_required do
      match ':controller/:action/'
      match 'moderator_panel', :to => 'moderator#show', :as => 'moderator/panel'
    end


    constraints admin_required do
      mount Resque::Server, :at => "/resque_admin/"
      mount Maktoub::Engine => "/maktoub/"
      match ':controller/:action/'
      resources :admin
      match 'admin_panel', :to => 'admin#show', :as => 'admin/panel'
    end


    resources :tokens, :only => [:create, :destroy]

  end
  #authenticate :admin do
  #  mount Resque::Server, :at => "/resque_admin"
  #end

end
