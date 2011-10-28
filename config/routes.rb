DemocracyOnline3::Application.routes.draw do
  match 'logout', :to => 'sessions#destroy', :as => 'logout'
  match 'login', :to => 'sessions#new', :as => 'login'
  match 'register', :to => 'users#create', :as => 'register'
  match 'signup', :to => 'users#new', :as => 'signup'
  match 'admin_panel', :to => 'admin#show', :as => 'admin/panel'

  root :to => 'proposals#index'
                                        
  resources :users do
    member do
      put :suspend
      put :unsuspend
      delete :purge
    end
  end
  
  resource :session
  
  resource :votation

  resources :groups

 
  resources :proposal_comments
  
  resources :proposals do
    resources :proposal_comments
  end
  
  resources :proposalcategories
  
  resources :blogs do 
    resources :blog_posts do
      match :tag, :on => :member
      match :drafts, :on => :collection 
      resources :blog_comments
    end
  end
  
#  map.resources :blog_posts, :collection => {:drafts => :any}, :member => {:tag => :any}, :has_many => :blog_comments
  resources :blogs do
    resources :blog_posts
  end
  
  resources :events 
  
  match ':controller/:action/:id'
  match ':controller/:action/:id.:format'
  
#  map.resources :blogs,
  
   match 'index_by_category', :to => 'proposals#index_by_category', :as => '/proposals/index_by_category'
  
  # match 'activate', :to  => 'users#activate', :as => '/activate/:activation_code'
   
  #  map.signup '/signup', :controller => 'users', :action => 'new'
#    map.login  '/login', :controller => 'sessions', :action => 'new'
 #   map.logout '/logout', :controller => 'sessions', :action => 'destroy'
   match 'forgot_password', :to => 'users#forgot_password', :as => '/forgot_password'
  #  map.reset_password '/reset_password/:id', :controller => 'users', 
    #                                          :action => 'reset_password'       
                                              
 #   map.new_session '/login', :controller => 'sessions', :action => 'new'                 
end
