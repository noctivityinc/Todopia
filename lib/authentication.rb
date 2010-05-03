# This module is included in your application controller which makes
# several methods available to all controllers and views. Here's a
# common example you might add to your application layout file.
# 
#   <% if logged_in? %>
#     Welcome <%=h current_user.login %>! Not you?
#     <%= link_to "Log out", logout_path %>
#   <% else %>
#     <%= link_to "Sign up", signup_path %> or
#     <%= link_to "log in", login_path %>.
#   <% end %>
# 
# You can also restrict unregistered users from accessing a controller using
# a before filter. For example.
# 
#   before_filter :login_required, :except => [:index, :show]
module Authentication
  def self.included(controller)
    controller.send :helper_method, :current_user, :logged_in?, :redirect_to_target_or_default
    controller.filter_parameter_logging :password
  end
  
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end
  
  def logged_in?
    current_user
  end
  
  def login_required
    unless logged_in?
      flash[:error] = "You must first log in or sign up before accessing this page."
      store_target_location
      redirect_to login_url
    end
  end
  
  def require_no_user
    if current_user
      store_target_location
      current_user_session.destroy if current_user_session
      current_user = nil
      redirect_to_target_or_default root_url
      return false
    end
  end
  
  def redirect_to_target_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
  def verify_user()
    if @user != current_user
      @user_session = UserSession.find
      @user_session.destroy
      flash.error = 'Unauthorized Access'
      redirect_to root_url
    end
  end
  
  private
  
  def store_target_location
    session[:return_to] = request.request_uri
  end
end
