DemocracyOnline3::Application.routes.draw do
  
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks"} do
    get '/users/sign_in' , :to => 'devise/sessions#new'  
    get '/users/sign_out', :to => 'devise/sessions#destroy'
    get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
  end
 
  

  root :to => 'proposals#index'
  
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
    end
    resources :proposal_comments do
      member do
        get :rankup
        get :rankdown        
      end
    end
    member do
      get  :rankup
      get :rankdown
      get :statistics
      post :set_votation_date
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
    end

    collection do
    end
    
    resources :events
    resources :blog_posts
   
  end

  
  match ':controller/:action/'
    
  resources :admin
  match 'admin_panel', :to => 'admin#show', :as => 'admin/panel'

  match '/votation/', :to => 'votations#show'
  match '/votation/vote', :to => 'votations#vote'
  resources :votations

  match ':controller/:action/:id'
  
 
  
  match ':controller/:action/:id.:format'
  
#  map.resources :blogs,
  
   match 'index_by_category', :to => 'proposals#index_by_category', :as => '/proposals/index_by_category'
  # match 'index_accepted', :to => 'proposals#index_accepted', :as => '/proposals/index_accepted'
  # match 'activate', :to  => 'users#activate', :as => '/activate/:activation_code'
   
  #  map.signup '/signup', :controller => 'users', :action => 'new'
#    map.login  '/login', :controller => 'sessions', :action => 'new'
 #   map.logout '/logout', :controller => 'sessions', :action => 'destroy'
#   match 'forgot_password', :to => 'users#forgot_password', :as => '/forgot_password'
  #  map.reset_password '/reset_password/:id', :controller => 'users', 
    #                                          :action => 'reset_password'       
                                              
 #   map.new_session '/login', :controller => 'sessions', :action => 'new'                 
end
