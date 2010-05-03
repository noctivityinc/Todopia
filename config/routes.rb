ActionController::Routing::Routes.draw do |map|

  map.resources :users, :controller => 'public/users', :shallow => true, :member => {:email => :get, :send_reset_password_email => :get} do |user|
    user.resources :todos, :controller => 'public/todos', :member => { :delete => :get, :uncheck => :get, :wait => :get}, :collection => {:reload  => :get, :filter => :get, :move => :post, :reorder => :post}  do |todo|
      todo.resources :histories, :controller => 'public/histories'
      todo.resources :notes, :controller => 'public/notes', :member => { :delete => :get }, :collection => {:list  => :get}
    end
    user.resource :tags,  :controller => 'public/tags', :only => [:show]
    user.resources :tag_groups, :controller => 'public/tag_groups', :only => :destroy, :member => { :delete => :get, :remove => :get, :check_all => :get, :rename => :get}, :collection => {:delete_unfiled  => :get, :check_unfiled  => :get}
    user.resources :invites
  end

  map.resources :reset_password, :controller => 'public/reset_password', :only => [:new, :create, :edit, :update]
  map.resources :user_sessions

  map.signup 'signup', :controller => 'public/users', :action => 'new'
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'
  map.login 'login', :controller => 'user_sessions', :action => 'new'


  map.connect 'flash', :controller => 'application', :action => 'load_flash'
  map.root :controller => 'public'
end
