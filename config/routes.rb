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

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks"} do
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
    end
  end                                      
  
  resources :notifications do
    collection do  
      get :change_notification_block
    end
  end
 
  resources :proposals do
    collection do
      get :index_accepted
      get :endless_index 
    end    
    resources :proposal_comments do
      member do
        get :rankup
        get :rankdown        
      end
    end
    
    resources :proposal_histories
    resources :proposal_supports
    
    member do
      get  :rankup
      get :rankdown
      get :statistics
      put :set_votation_date
    end
  end
  
  resources :proposalcategories
  
  resources :blogs do 
    resources :blog_posts do
      match :tag, :on => :member
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
      get :get_events
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
      get :get_events
      get :edit_permissions
    end

    collection do
    end
    
    resources :events
       
  end

  resources :partecipation_roles do
    collection do
      post :change_group_permission
    end
  end
 

  match '/votation/', :to => 'votations#show'
  match '/votation/vote', :to => 'votations#vote'
  resources :votations

  match ':controller/:action/:id'
  
 
  
  match ':controller/:action/:id.:format'
    
  match 'index_by_category', :to => 'proposals#index_by_category', :as => '/proposals/index_by_category'
  
  match 'home', :to => 'home#show'
  
  admin_required = lambda do |request|
    request.env['warden'].authenticate? and request.env['warden'].user.admin?
  end

  constraints admin_required do
    mount Resque::Server, :at => "/resque_admin/"
    
    match ':controller/:action/'
    resources :admin
    match 'admin_panel', :to => 'admin#show', :as => 'admin/panel'
  end

  
  #authenticate :admin do
  #  mount Resque::Server, :at => "/resque_admin"
  #end
                     
end
