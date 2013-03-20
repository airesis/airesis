DemocracyOnline3::Application.routes.draw do


  resources :tutorial_progresses

  resources :tutorials do
    resources :steps  do
      member do
        get :complete
      end
    end
    resources :tutorial_assignees
  end

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks", :registrations => "registrations"} do
    get '/users/sign_in' , :to => 'devise/sessions#new'  
    get '/users/sign_out', :to => 'devise/sessions#destroy'
    get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
  end
 
  

  root :to => 'home#index'
  
  #match ':controller/:action/:id'
  
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
    end

    member do
      get :show_message
      post :send_message
    end
  end                                      
  
  resources :notifications do
    collection do  
      post :change_notification_block
      post :change_email_notification_block
      post :change_email_block
    end
  end
 
  resources :proposals do
    collection do
      get :index_accepted
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
      end
      collection do
        post :list
      end
    end

    resources :proposal_histories
    resources :proposal_supports

    member do
      get :rankup
      get :rankdown
      get :statistics
      put :set_votation_date
      post :available_author
      get :available_authors_list
      put :add_authors
      get :vote_results
    end
  end

  resources :proposalcategories

  resources :blogs do
    resources :blog_posts do
      #match :tag, :on => :member
      match :drafts, :on => :collection 
      resources :blog_comments
    end
  end
  
  
  resources :blog_posts
  
  resources :alerts do
    member do
      get :check_alert
    end
    
    collection do
      get :polling
      get :read_alerts
    end
  end

 resources :interest_borders
 resources :comunes

  
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

  resources :group_partecipations
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
    
    resources :proposals
    
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

  resources :partecipation_roles do
    collection do
      post :change_group_permission
      post :change_user_permission
      post :change_default_role
    end
  end


  match 'elfinder' => 'elfinder#elfinder'

  match '/tags/:text', :to => 'tags#show', :as => 'tag'

  match '/votation/', :to => 'votations#show'
  match '/votation/vote', :to => 'votations#vote'
  resources :votations

  match ':controller/:action/:id'
    
  match ':controller/:action/:id.:format'
    
  match 'index_by_category', :to => 'proposals#index_by_category', :as => '/proposals/index_by_category'
  
  match 'home', :to => 'home#show'
  
  #url friendly 'proposte'
  #match ':proposal_url/:id', :to => 'proposals#show'
  #match ':proposal_url', :to => 'proposals#index'
  #match ':proposal_url/cat/:category/', :to => 'proposals#index'
  
  match '/partecipa' => 'home#engage'
  match '/chisiamo' => 'home#whowe'
  match '/roadmap' => 'home#roadmap'
  match '/videoguide' => 'home#videoguide'
  match '/edemocracy' => 'home#whatis'
  match '/sostienici' => 'home#helpus'

  admin_required = lambda do |request|
    request.env['warden'].authenticate? and request.env['warden'].user.admin?
  end

  constraints admin_required do
    mount Resque::Server, :at => "/resque_admin/"
    mount Maktoub::Engine => "/maktoub/"
    match ':controller/:action/'
    resources :admin
    match 'admin_panel', :to => 'admin#show', :as => 'admin/panel'
  end

  
  #authenticate :admin do
  #  mount Resque::Server, :at => "/resque_admin"
  #end
                     
end
