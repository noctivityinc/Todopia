ActionController::Routing::Routes.draw do |map|

  map.resources :users, :controller => 'public/users', :shallow => true,  do |user|
    user.resources :todos, :controller => 'public/todos', :member => { :delete => :get, :filter => :get, :uncheck => :get }, :collection => {:reload  => :get, :update_order => :get}  do |todo|
      todo.resources :histories, :controller => 'public/histories'
      todo.resources :notes, :controller => 'public/notes', :member => { :delete => :get }, :collection => {:list  => :get} 
    end
    user.resource :tags,  :controller => 'public/tags', :only => [:show]
    user.resources :tag_groups, :controller => 'public/tag_groups', :only => :destroy, :member => { :delete => :get, :remove => :get, :check_all => :get }
  end

  map.resources :user_sessions
  map.resources :invites

  map.signup 'signup', :controller => 'public/users', :action => 'new'
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'
  map.login 'login', :controller => 'user_sessions', :action => 'new'

  map.connect 'flash', :controller => 'application', :action => 'load_flash'
  map.root :controller => 'public'

end
